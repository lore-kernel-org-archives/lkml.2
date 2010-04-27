Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab0D0Sd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:33:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50534 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751823Ab0D0SdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:33:24 -0400
Date: Tue, 27 Apr 2010 14:33:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
       <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 2/9] PM: suspend_block: Add driver to access
  suspend blockers from user-space
In-Reply-To: <y2nd6200be21004262104mb81ba7d6xe5c8f35689ca20a0@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1004271432280.1850-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Apr 2010, Arve Hjønnevåg wrote:

> > If you insist on using ioctl for init, you should use the standard
> > convention for passing variable-length data.  The userspace program
> > sets up a fixed-size buffer containing a pointer to the name and the
> > name's length, and it passes the buffer's address as the ioctl
> > argument.
> 
> Are you sure that is the standard? I searched for ioctls with NAME in
> their name and only found one that passed the name that way. The rest
> used fixed length string buffers, or passed the buffersize to _IOC
> like I do. For instance, input.h has ioctls to read string and
> bitmasks where user space specify the buffer size as an argument to
> the ioctl macro. These pass data from the kernel to user space, but I
> don't passing a string length is any worse than passing a buffer size.

You're right.  Okay, I withdraw my objection.

Alan Stern

