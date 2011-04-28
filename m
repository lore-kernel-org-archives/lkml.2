Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab1D1MMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 08:12:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60039 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab1D1MMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 08:12:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Date: Thu, 28 Apr 2011 14:12:40 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Valdis.Kletnieks@vt.edu, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201104212129.17013.arnd@arndb.de> <11431.1303949729@localhost> <1303979259.26744.3.camel@e102109-lin.cambridge.arm.com>
In-Reply-To: <1303979259.26744.3.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104281412.40991.arnd@arndb.de>
X-Provags-ID: V02:K0:XAuqkYyWYs3R3VCllfWdfFaflckdjeyaSMn+GODCqx3
 FZelisf9jbbHqr4m2/eKFpuJYC/FgyuOQl1aPmKHPc+bdRf48j
 4aiB+7OSzGs/wyZY+0IJ7q+RDwRcT7ZfoL1tIAoR5X2xqbv/uA
 HvnB+7RZ6r48/E3mBbA5Y12xvh33X8fey/Te9q2vaJWlK0w2vV
 PaS+xIb/JdEX/AMpIN2TA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 April 2011, Catalin Marinas wrote:
> On Thu, 2011-04-28 at 01:15 +0100, Valdis.Kletnieks@vt.edu wrote:
> > On Wed, 27 Apr 2011 12:08:28 BST, Catalin Marinas said:
> > 
> > > The current version of the ARM ARM says "unpredictable". But this
> > > general definition of "unpredictable" does not allow it to deadlock
> > > (hardware) or have security implications. It is however allowed to
> > > corrupt data.
> > 
> > Not allowed to have security implications, but is allowed to corrupt data.
> 
> By security I was referring to TrustZone extensions. IOW, unpredictable
> in normal (non-secure) world should not cause data corruption in the
> secure world.

That definition is rather useless for operating systems that don't use
Trustzone then, right?

	Arnd
