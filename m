Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271Ab1CXUnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:43:32 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:26938 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933787Ab1CXUn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:43:29 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: oX_tVUwVM1n9qVDbpi067uktsoCejauUY0sPOsJaCtoXytX
 qIhGpyf4_3HO3Snz80OsFiwyPhweUsq8BQFGUIO7uIP2DXLD0y9nnP3AkSdK
 QhxhHgV7QMKkoylX__8DrXmgxoYE94YphaWfqALqP.pYqkiqnFevieynepEM
 GYqrJRqd_LWSXifxaYbHqn2MGbrzGtb4Q1rcStQX0axkoTMlQvO4exAQRcwT
 AUk8QYL6o.gJ_5SUx0sAjh4uChqpmWBD3A0FuJYrIQJWrSyQj7wxC6abfc0p
 0FR05jX.1XbGuDhvwyMz8vHosbzlCoB.JDFjpcUh7yVtfcUuf
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 24 Mar 2011 15:43:25 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, npiggin@kernel.dk,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
In-Reply-To: <1300997290.2714.2.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1103241541560.8108@router.home>
References: <alpine.DEB.2.00.1103241300420.32226@router.home>  <AANLkTi=KZQd-GrXaq4472V3XnEGYqnCheYcgrdPFE0LJ@mail.gmail.com>  <alpine.DEB.2.00.1103241312280.32226@router.home>  <1300990853.3747.189.camel@edumazet-laptop>  <alpine.DEB.2.00.1103241346060.32226@router.home>
  <AANLkTik3rkNvLG-rgiWxKaPc-v9sZQq96ok0CXfAU+r_@mail.gmail.com>  <20110324185903.GA30510@elte.hu>  <AANLkTi=66Q-8=AV3Y0K28jZbT3ddCHy9azWedoCC4Nrn@mail.gmail.com>  <alpine.DEB.2.00.1103241404490.5576@router.home>  <AANLkTimWYCHEsZjswLpD-xDcu_cL=GqsMshKRtkHt5Vn@mail.gmail.com>
  <20110324193647.GA7957@elte.hu>  <AANLkTinBwKT3s=1En5Urs56gmt_zCNgPXnQzzy52Tgdo@mail.gmail.com>  <alpine.DEB.2.00.1103241451060.5576@router.home> <1300997290.2714.2.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011, Eric Dumazet wrote:

> Thats strange, alloc_percpu() is supposed to zero the memory already ...

True.

> Are you sure its really this problem of interrupts being disabled ?

Guess so since Ingo and Pekka reported that it fixed the problem.

Tejun: Can you help us with this mystery?
