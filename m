Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab2DTOVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:21:09 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:43552 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab2DTOVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:21:07 -0400
Date: Fri, 20 Apr 2012 07:21:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rigels Gordani <rgordani@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 0003-Staging-fix-coding-style-issues-and-some-minor-code-
Message-ID: <20120420142103.GA19609@kroah.com>
References: <CAKHmb3PrPJY95pcXVeBe4_UjVSKbSM4JjDJ1totREaaLxr_Sqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKHmb3PrPJY95pcXVeBe4_UjVSKbSM4JjDJ1totREaaLxr_Sqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 12:24:03PM +0200, Rigels Gordani wrote:
> Hi,
> this is my first patch in the official linux tree, hope I have done everything
> OK :).
> 
> 0003-Staging-fix-coding-style-issues-and-some-minor-code-.patch
> 0002-Revert-Staging-fix-coding-style-issues-and-some-mino.patch

Why are you sending multiple patches as attachments, and one of them
being a revert for no good reason?

Please read the file, Documentation/SubmittingPatches and use git
send-email to send patches out to everyone involved.  For examples of
how they should be sent, look at the mailing lists for posted patches.

hope this helps,

greg k-h

