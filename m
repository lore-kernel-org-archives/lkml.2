Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab1LZQRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 11:17:32 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:22716 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751417Ab1LZQR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 11:17:29 -0500
X-IronPort-AV: E=Sophos;i="4.71,411,1320620400"; 
   d="scan'208";a="136901142"
Date: Mon, 26 Dec 2011 17:17:26 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Samuel Ortiz <sameo@linux.intel.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: devm_kfree
In-Reply-To: <20111226142354.GI8722@opensource.wolfsonmicro.com>
Message-ID: <alpine.DEB.2.02.1112261716310.1873@localhost6.localdomain6>
References: <1324661974-17281-1-git-send-email-julia@diku.dk> <20111226120855.GB17760@sirena.org.uk> <alpine.DEB.2.02.1112261440450.1873@localhost6.localdomain6> <20111226142354.GI8722@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And I guess that eg using kfree to free something allocated using 
devm_kzalloc would be completely wrong, leading to a dangling pointer?

julia
