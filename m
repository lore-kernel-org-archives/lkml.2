Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab1JQTHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 15:07:03 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64225 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab1JQTHB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 15:07:01 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1110171426520.1749-300000@iolanthe.rowland.org>
References: <CA+O4pCKKOvjRmgpC1fijzmpKOMQGdb1vkKeiSgFTY3Sv7xeaoQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1110171426520.1749-300000@iolanthe.rowland.org>
Date: Mon, 17 Oct 2011 21:07:00 +0200
Message-ID: <CA+O4pCJ3iihLBr0W61Z1uQAAw4tk7aTLv-0=iAP0qFPYKL9zYw@mail.gmail.com>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB list <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 8:38 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> Markus:
>
> Attached is a sequence of two patches for you to try out.  The second
> is meant to be applied on top of the first.  I based them on 3.1-rc4
> (more or less) so they may need a little tweaking for your kernel, but
> hopefully not very much.
>
> The first patch simplifies the error pathways for the USB submission
> routines in usbfs.  The second patch removes the limits on the sizes of
> individual URBs and replaces them with a global limit on the total
> amount of memory allocated by usbfs.
>
> They work okay on my system but I don't have any good way to give them
> a thorough test.  Please try them out and see if they allow your webcam
> programs to work properly.
>

will go through it within the next 1-2 days, just a bit busy with
other things now..

thanks,
Markus
> Alan Stern
>
