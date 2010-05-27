Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab0E0XmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 19:42:22 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:56928 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758379Ab0E0XmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 19:42:18 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Florian@smtp1.linux-foundation.org,
       Linux@smtp1.linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
       List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>, felipe.balbi@nokia.com
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
	<20100527174019.GA3187@srcf.ucam.org>
	<1274982447.27810.5684.camel@twins> <201005280041.43553.rjw@sisk.pl>
	<20100528001514.28e593ef@lxorguk.ukuu.org.uk>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 27 May 2010 16:42:15 -0700
In-Reply-To: <20100528001514.28e593ef@lxorguk.ukuu.org.uk> (Alan Cox's message of "Fri\, 28 May 2010 00\:15\:14 +0100")
Message-ID: <87fx1cgbe0.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> - Given a non forced (that is 'idle down') transition to a suspend level
>   we can implement a 'suspend as idle' on many embedded platforms in a
>   manner which is not racy at kernel level. Apparently implemented
>   already on ARM

Just to confirm, yes, it is already implemeted on ARM, and in mainline
for the TI OMAP3 (ARM Cortex-A8) and in commercial products (Nokia
N900, Moto Droid, Palm Pre, Archos, etc.)  For the OMAP the deepest
C-state is actually a fully powered-down ARM core.

While the Droid uses 'suspend as idle' in addition to opportunistic
suspend, the N900 *never* suspends in the traditional sense, it is
entirely idle based.

Kevin
