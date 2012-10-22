Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab2JVPyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:54:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53346 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754236Ab2JVPyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:54:38 -0400
Date: Mon, 22 Oct 2012 11:54:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Mack <zonque@gmail.com>
cc: "Artem S. Tashkinov" <t.artem@lycos.com>, <bp@alien8.de>, <pavel@ucw.cz>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <security@kernel.org>, <linux-media@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <alsa-devel@alsa-project.org>
Subject: Re: A reliable kernel panic (3.6.2) and system crash when visiting
 a particular website
In-Reply-To: <5085667A.70408@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1210221153140.1724-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012, Daniel Mack wrote:

> On 22.10.2012 17:17, Alan Stern wrote:
> > On Sun, 21 Oct 2012, Artem S. Tashkinov wrote:
> > 
> >> dmesg messages up to a crash can be seen here: https://bugzilla.kernel.org/attachment.cgi?id=84221
> > 
> > The first problem in the log is endpoint list corruption.  Here's a 
> > debugging patch which should provide a little more information.
> 
> Maybe add a BUG() after each of these dev_err() so we stop at the first
> occurance and also see where we're coming from?

A BUG() at these points would crash the machine hard.  And where we
came from doesn't matter; what matters is the values in the pointers.

Alan Stern

