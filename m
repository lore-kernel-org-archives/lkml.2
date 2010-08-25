Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab0HYVhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 17:37:23 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:45312 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754663Ab0HYVhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 17:37:20 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: OpDhNRgVM1kKz9ygK8rR9Kz2e2v58RQ6Pz46qcjyLBEBHPz
 60f8nH3RDKv.xbQS_LuhAn1B9M3I5IGwkY83Teqr3Du8CRAAU1qIw9DZzm5e
 HefxLS2R519tg_KsJiMYi88XAgHof83jtGPiEtj2CD4h.p5DF7pRLBnHU8h1
 cVGwMGnBPK7VCbcq7ZOlggLu3m_Aqs.hCRlKOTuyl.eANx8e9h7U92koLgzd
 yz8zIuXonUgTbcO6W3M2wZL7s7BA-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 25 Aug 2010 16:37:16 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (slab
 tree related)
In-Reply-To: <alpine.DEB.2.00.1008251509080.22117@router.home>
Message-ID: <alpine.DEB.2.00.1008251635560.25892@router.home>
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <alpine.DEB.2.00.1008241256280.4763@router.home> <4C741029.7090300@cs.helsinki.fi> <alpine.DEB.2.00.1008241352240.5388@router.home> <4C74D1D7.4080608@kernel.org>
 <alpine.DEB.2.00.1008251509080.22117@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Err... Sorry there was patch under testing in there (remove the boot
pageset from the page allocator and use early allocpercpu) which resulted
in the reserve area becoming a bit tight. Sorry.


