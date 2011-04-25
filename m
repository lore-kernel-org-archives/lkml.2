Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab1DYURc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:17:32 -0400
Received: from nat-warsl417-02.aon.at ([195.3.96.120]:40473 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751095Ab1DYURb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:17:31 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Apr 2011 16:17:31 EDT
From: Melchior FRANZ <melchior.franz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: i915 completely unusable in 2.6.38.x
Date: Mon, 25 Apr 2011 22:10:46 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.4; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <greg@kroah.com>
References: <4DB53B79.4070704@kernelpanic.ru>
In-Reply-To: <4DB53B79.4070704@kernelpanic.ru>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104252210.46523@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Boris B. Zhmurov -- Monday 25 April 2011:
> After upgrading RHEL6 to 2.6.28.x kernel, I have spontaneous "GPU hung"
> 5-6 times per day.
> xorg-x11-drv-intel-2.11.0-7.el6.i686 driver for Xorg.

JFTR, and although it seems to be a totally different problem with i915
(or rather gm45), the whole 2.6.38.* series is also of limited use on my
notebook, as described in this error message:

   https://bugzilla.kernel.org/show_bug.cgi?id=31522

I'm still using 2.6.38-rc8 (with SuSE 11.4/tumbleweed) on this machine
(Acer TravelMate 5735Z-452G32Mnss), because that's the last version that
supported KMS on my chipset. This older version works ok, so there's no
reason to complain, but I'm still a bit suprised about that regression.

m.
