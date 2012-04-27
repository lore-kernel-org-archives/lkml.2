Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab2D0GLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:11:14 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65331 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2D0GLM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 02:11:12 -0400
MIME-Version: 1.0
X-Originating-IP: [189.105.198.102]
In-Reply-To: <20120427013225.GA1011@pervalidus>
References: <20120427013225.GA1011@pervalidus>
Date: Fri, 27 Apr 2012 03:11:11 -0300
Message-ID: <CAJK5xJRPF1XtXXYtZ_GQONstPrBa_eaeqW=XACSx+giFWBpfnQ@mail.gmail.com>
Subject: Re: What may be causing this kernel panic ?
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?= 
	<fredlwm@fredlwm.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/26 Frédéric L. W. Meunier:
> I don't know if it's a bug in the kernel, a miscompilation or anything
> else, but as soon as I start the Midnight Commander file manager on a
> Linux console, what I didn't do for some time, and press F3 to read any
> file, even a very small text file, I get the attached kernel panic and
> need to force a reboot.
>
> Another strange thing is that I can't reproduce it if I start 'mc' from
> a X terminal emulator.
>
> Also, the screenshot was made from a VirtualBox session, but the same
> kernel (3.3.3) crashes my Linux installation too. I'm also attaching my
> .config if it can be of any use to know where to start.

https://sites.google.com/a/fredlwm.net/fredlwm/home/kernelpanic2.png
is more complete and shows something about the keyboard, I guess.
