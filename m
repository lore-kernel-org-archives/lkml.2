Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab0ELUw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 16:52:27 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45506 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757632Ab0ELUwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 16:52:25 -0400
Subject: Re: PROBLEM: tickless scheduling
From: john stultz <johnstul@us.ibm.com>
To: Donald Allen <donaldcallen@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <AANLkTilb_CGBolyv5Ps9VuhNxFZKtjck4om4G21ICaif@mail.gmail.com>
References: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>
	 <AANLkTikjgoBQWqvNxncMUFqWOEXtq4ePvGkvF-m0sGUE@mail.gmail.com>
	 <AANLkTimnlZYonxKzfGHZTV8vwaDptOPHEPBjNhwnV55Y@mail.gmail.com>
	 <1273540344.3843.101.camel@localhost.localdomain>
	 <AANLkTilg2cn3lAIOruz6oZE7V-9uAFDORlbvTX3qxmwF@mail.gmail.com>
	 <AANLkTilb_CGBolyv5Ps9VuhNxFZKtjck4om4G21ICaif@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 13:52:03 -0700
Message-ID: <1273697523.2856.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 15:54 -0400, Donald Allen wrote:
> Before doing what you asked, I ran my home-brew backup script, which
> tars up the whole machine, save my home directory, to a big sata drive
> in a usb shoebox. I did so by booting the most recent Arch Linux
> install/live CD (while I use Slackware, the Slackware install CDs are
> not suitable for this sort of thing, having very old versions of
> things like tar). While doing so, I observed exactly the same symptoms
> I did with the Slackware 13.1 install, which I described in the bug
> report. So rather than messing with the hard-won custom kernel that I
> now have installed on the netbook, I am attaching the various things
> from /proc gathered with the Arch kernel running. Yes, it's a somewhat
> older kernel (2.6.30), but I'm hoping that things haven't changed much
> in tickless land. If that's not the case, then I will attempt to
> reproduce this with the newer kernel on the Slackware 13.1 install
> DVD. Let me know if you need me to do this. The attached tar file is
> bzip2-compressed, so you want xjf to extract.

Hmm.. Sorry, but I have another quick request. Could you send
your /proc/interrupts output from the kernel having the problem?

thanks
-john


