Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab2BRJDJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 04:03:09 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34522 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751628Ab2BRJDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 04:03:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of penberg@gmail.com designates 10.152.108.49 as permitted sender) smtp.mail=penberg@gmail.com; dkim=pass header.i=penberg@gmail.com
Date: Sat, 18 Feb 2012 11:02:55 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: "Alex,Shi" <alex.shi@intel.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cl@linux.com" <cl@linux.com>
Subject: Re: [rfc PATCH]slub: per cpu partial statistics change
In-Reply-To: <1329462406.12669.2919.camel@debian>
Message-ID: <alpine.LFD.2.02.1202181102110.2447@tux.localdomain>
References: <1328256695.12669.24.camel@debian>  <alpine.DEB.2.00.1202030920060.2420@router.home>  <4F2C824E.8080501@intel.com>  <alpine.DEB.2.00.1202060858510.393@router.home>  <1328591165.12669.168.camel@debian>  <alpine.DEB.2.00.1202070910320.29500@router.home>
  <1328676290.12669.431.camel@debian>  <alpine.DEB.2.00.1202080846030.29839@router.home> <1329462406.12669.2919.camel@debian>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Feb 2012, Alex,Shi wrote:
> Pakka:
> Would you like to pick up this patch? It works on latest Linus' tree.

Applied, thanks! Can you please use my @kernel.org email address in the 
future? I don't really follow this account as often.

 			Pekka
