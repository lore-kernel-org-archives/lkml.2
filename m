Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab2JUPXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 11:23:33 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33641 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932129Ab2JUPXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 11:23:31 -0400
Date: Sun, 21 Oct 2012 11:23:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Artem S. Tashkinov" <t.artem@lycos.com>
cc: bp@alien8.de, <pavel@ucw.cz>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <security@kernel.org>,
        <linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Re: Re: Re: Re: A reliable kernel panic (3.6.2) and system crash
 when visiting a particular website
In-Reply-To: <121566322.100103.1350820776893.JavaMail.mail@webmail20>
Message-ID: <Pine.LNX.4.44L0.1210211121370.14867-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2012, Artem S. Tashkinov wrote:

> What I've found out is that my system crashes *only* when I try to enable
> usb-audio (from the same webcam) - I still have no idea how to capture a
> panic message, but I ran
> 
> "while :; do dmesg -c; done" in xterm, then I got like thousands of messages
> and I photographed my monitor:
> 
> http://imageshack.us/a/img685/9452/panicz.jpg
> 
> list_del corruption. prev->next should be ... but was ...
> 
> I cannot show you more as I have no serial console to use :( and the kernel
> doesn't have enough time to push error messages to rsyslog and fsync
> /var/log/messages

Is it possible to use netconsole?  The screenshot above appears to be 
the end of a long series of error messages, which isn't too useful.  
The most important information is in the first error.

Alan Stern

