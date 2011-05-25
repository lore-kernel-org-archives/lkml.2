Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab1EYO6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:58:19 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:28549 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754489Ab1EYO6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:58:16 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: r3YOEfEVM1mgGlBH5..MUj5cDLWqrtJ51k_qh8Nm7dGBJC8
 .lSnxZmoeW8gEwv2NXA711L8uyMYTTq3aTBYXNCVX91yAr.uVcu3HPuff3b0
 eGVPP3VGLLSpbL.sXW4hHifyb.WLQvpybcHXuVHM9RsrtHA8X6PzeJaW2mOP
 SueQWjHU4gKFYrp.0jIWi8qga_WwnlsIVS8FQCrqYCOz8VK2QjRYw5L1gnrB
 up64_5tC_oASOfeSgqXiiAF4IfvWw69QhVe33p_9eIwQhD9e6S0_vWqvliBw
 KCjWzVZVeDEV27AS35EFVjsNdM1yUgBr2m4uxqa7OugARuVF2z4Z_eq9EHe5
 gKEySTLe_oyi2FR.HILivaDY-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 25 May 2011 09:58:13 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] slub: avoid compiling SLAB_CACHE_DMA without DMA
 support
In-Reply-To: <alpine.DEB.2.00.1105241652110.29780@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1105250957180.23309@router.home>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com> <alpine.DEB.2.00.1105241652110.29780@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, David Rientjes wrote:

> If CONFIG_ZONE_DMA is disabled, SLAB_CACHE_DMA is a no-op.  Avoid
> compiling support for it on such a configuration.

Setting SLAB_CACHE_DMA to zero in the !ZONE_DMA case could avoid some of
the ifdeffery.

