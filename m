Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab2HNUBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 16:01:49 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65261 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab2HNUBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 16:01:47 -0400
MIME-Version: 1.0
In-Reply-To: <BCB48C05FCE8BC4D9E61E841ECBE6DB70E3D47@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1344500375-8457-1-git-send-email-qiang.liu@freescale.com>
	<20120809170307.GG14264@ovro.caltech.edu>
	<BCB48C05FCE8BC4D9E61E841ECBE6DB70E3D47@039-SN2MPN1-013.039d.mgd.msft.net>
Date: Tue, 14 Aug 2012 13:01:46 -0700
X-Google-Sender-Auth: nMKRLoDlDjxlIWn70r13cbT7_mw
Message-ID: <CAA9_cme4tHrx14JaSaHwgcGq79qQK5bv8E205fbC3ega5OpUiQ@mail.gmail.com>
Subject: Re: [PATCH v7 0/8] Raid: enable talitos xor offload for improving performance
From: Dan Williams <djbw@fb.com>
To: Liu Qiang-B32616 <B32616@freescale.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 2:04 AM, Liu Qiang-B32616 <B32616@freescale.com> wrote:
> Hi Vinod,
>
> Would you like to apply this series from patch 2/8 to 7/8) in your tree?
> The link as below,
> http://patchwork.ozlabs.org/patch/176023/
> http://patchwork.ozlabs.org/patch/176024/
> http://patchwork.ozlabs.org/patch/176025/
> http://patchwork.ozlabs.org/patch/176026/
> http://patchwork.ozlabs.org/patch/176027/
> http://patchwork.ozlabs.org/patch/176028/
>

Hi, sorry for the recent silence I've been transitioning and am now
just catching up.  I'll take a look and then it's fine for these to go
through Vinod's tree.

--
Dan
