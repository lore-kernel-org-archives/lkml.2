Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab1DLSlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:41:17 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:48023 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981Ab1DLSlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:41:16 -0400
From: Richard Weinberger <richard@nod.at>
To: Christoph Lameter <cl@linux.com>
Subject: Re: um: this_cpu_cmpxchg16b_emu
Date: Tue, 12 Apr 2011 20:41:11 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        penberg@kernel.org, hpa@zytor.com
References: <201104121609.56901.richard@nod.at> <alpine.DEB.2.00.1104121309480.14692@router.home>
In-Reply-To: <alpine.DEB.2.00.1104121309480.14692@router.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104122041.11460.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 12 April 2011, 20:10:37 schrieb Christoph Lameter:
> On Tue, 12 Apr 2011, Richard Weinberger wrote:
> > This patch implements this_cpu_cmpxchg16b_emu() for UML.
> 
> Is this really necessary? Just undefine CONFIG_CMPXCHG_LOCAL for UML and
> the asm code will not be used.

UML includes arch/x86/Kconfig.cpu which defines CONFIG_CMPXCHG_LOCAL automatically.
Just disabling CONFIG_CMPXCHG_LOCAL for UML is IMHO not very nice.
When chpxchg is available also UML should use it...

Thanks,
//richard
