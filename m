Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949Ab1DZH77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 03:59:59 -0400
Received: from smtpout06.highway.telekom.at ([195.3.96.89]:59088 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758413Ab1DZH75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 03:59:57 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: i915 completely unusable in 2.6.38.x
Date: Tue, 26 Apr 2011 09:59:52 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.4; KDE/4.6.0; x86_64; ; )
References: <4DB53B79.4070704@kernelpanic.ru> <201104252210.46523@rk-nord.at> <20110425210323.GA23418@kroah.com>
In-Reply-To: <20110425210323.GA23418@kroah.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Greg KH <greg@kroah.com>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104260959.53084@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't really want to hijack this thread -- just confirm that the i915
driver is/was broken through the whole 2.6.38 series, up to 2.6.38.4.



* Greg KH -- Monday 25 April 2011:
> On Mon, Apr 25, 2011 at 10:10:46PM +0200, Melchior FRANZ wrote:
> > I'm still using 2.6.38-rc8 (with SuSE 11.4/tumbleweed) on this machine
> > (Acer TravelMate 5735Z-452G32Mnss), because that's the last version that
> > supported KMS on my chipset.

> I don't understand, .38 should work as it has the above fix in it,
> right?

[https://bugzilla.kernel.org/show_bug.cgi?id=31522]
Argh, sorry -- I hadn't noticed that someone closed this bug report.
No, this isn't fixed. Exact same symptoms: The notebook's screen 
goes black early in the boot process with KMS. Closing and reopening
the lid doesn't help, contrary to what some people reported. Turning
off KMS kind-of helps: The virtual console is right after that, but
Xorg apparently gets contradicting info about the screen size, so
that parts of the desktop end up outside the screen area.



> Otherwise, what should be done for the .38-stable tree?

I had assumed that the commit that broke it was known, as there hasn't
much been committed between 2.6.38-rc8 and 26.6.38, but I'll bisect
and investigate.

m.
