Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab1I0SIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:08:55 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11505 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab1I0SIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:08:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 27 Sep 2011 11:08:37 -0700
Date: Tue, 27 Sep 2011 21:08:34 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Olof Johansson <olof@lixom.net>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] arm/tegra: add support for ventana pinmuxing
Message-ID: <20110927180834.GI21166@tbergstrom-lnx.Nvidia.com>
References: <1317143421-27286-1-git-send-email-pdeschrijver@nvidia.com>
 <1317143421-27286-3-git-send-email-pdeschrijver@nvidia.com>
 <CAOesGMjqhGYUQ2XmuBBTBSUA6mKnOLF=Hmi86hRQhLiUMPtiBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAOesGMjqhGYUQ2XmuBBTBSUA6mKnOLF=Hmi86hRQhLiUMPtiBg@mail.gmail.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 07:36:24PM +0200, Olof Johansson wrote:
> Hi,
> 
> The series looks reasonable to me, I'll apply it together with some of
> the other pending tegra patches from the list. Once Stephen's pinmux
> devicetree code is in place some of this can be removed.
> 
> One comment on this patch description though:
> 
> 
> On Tue, Sep 27, 2011 at 10:10 AM, Peter De Schrijver
> <pdeschrijver@nvidia.com> wrote:
> > Add support for ventana pinmuxing as a seaboard derivative. This is a cut down
> > version of chromeos kernel commit 772f1b56e713be7a55759c2d5eadb9eb11d078db
> > by Jong Kim <jongk@nvidia.com>.
> 
> Having a reference to a SHA1 in a foreign source tree isn't really
> useful in the mainline kernel commit log.
> 
> I would just phrase it "This is a cut down version of work done by <....>"
> 

Ok. I will resend this series with the updated description.

Cheers,

Peter.
