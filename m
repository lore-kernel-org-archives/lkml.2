Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab0JGViG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:38:06 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53434 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0JGViE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:38:04 -0400
Date: Thu, 7 Oct 2010 22:37:54 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mario Limonciello <superm1@ubuntu.com>,
        Keng-Yu Lin <keng-yu.lin@canonical.com>, len.brown@intel.com,
        alan-jenkins@tuffmail.co.uk, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dell-laptop: Add hwswitch_only module parameter
Message-ID: <20101007213754.GA1896@srcf.ucam.org>
References: <1286422207-14248-1-git-send-email-keng-yu.lin@canonical.com> <20101007111510.GA19624@srcf.ucam.org> <AANLkTinus8SxbXt14qabXgpbFXF4U+uNoKA-=eDuOjmp@mail.gmail.com> <20101007133529.GA21782@srcf.ucam.org> <AANLkTi=kTQpTkCF6-DE+LdNLH_aki9bD9NPF0L2qRr=Q@mail.gmail.com> <20101007205049.GB32726@srcf.ucam.org> <AANLkTi=bj3T5hcX9r3j5kyEQkNb7PAZK948kcrx4R8tC@mail.gmail.com> <20101007213027.GA18628@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101007213027.GA18628@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 02:30:28PM -0700, Dmitry Torokhov wrote:

> We have this strategy for bunch of input stuff (force release, keymap)
> and I think it works better than dding more and more DMI quirks into
> kernel itself.

It's limited to Dell hardware, so I think keeping a static list in the 
Dell laptop driver is reasonable. All we need is a list of hardware, and 
I'd really hope that Dell know which BIOS versions contain this code!

-- 
Matthew Garrett | mjg59@srcf.ucam.org
