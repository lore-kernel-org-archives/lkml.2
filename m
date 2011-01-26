Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab1A1Gek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 01:34:40 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:43907 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab1A1Gea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 01:34:30 -0500
Date: Wed, 26 Jan 2011 23:13:18 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 1/3] Move zone_reclaim() outside of CONFIG_NUMA (v4)
Message-ID: <20110126174318.GQ2897@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110125050255.13141.688.stgit@localhost6.localdomain6>
 <20110125050430.13141.21260.stgit@localhost6.localdomain6>
 <alpine.DEB.2.00.1101261008440.23080@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101261008440.23080@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter <cl@linux.com> [2011-01-26 10:56:56]:

> 
> Reviewed-by: Christoph Lameter <cl@linux.com>
>

Thanks for the review! 

-- 
	Three Cheers,
	Balbir
