Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab0ICRSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 13:18:12 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:48989 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756224Ab0ICRSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 13:18:10 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: PYH3wjAVM1nCo8hXgQdIpfGo_Xp0.aP_zSuWTOUftjzUBCz
 hiqBEggHtlfibqy3mGRT5T4xwu7rvSweKKjva2IlICu8FKgDZKqX_.pNdN.T
 aA5HhxwDlbv1HtUWpYjhADaICQgaYDiXUtwKLGT8bgb1L6ZbvkOWMSMqUkn0
 AjAGIscQrHFNENyqUNvzyE3DMVUUPQxbvVC7rVBUJdqIWllAGssMKz4ZoS.3
 ngkOM0xua5pu9q8tSJvT465ZyptuqzR1iqYN59gsVB.VNXOPx82nQIJYcc0I
 e.6aohg--
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 3 Sep 2010 12:18:07 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] percpu: reduce PCPU_MIN_UNIT_SIZE to 32k
In-Reply-To: <4C8121A1.8060809@kernel.org>
Message-ID: <alpine.DEB.2.00.1009031217510.8658@router.home>
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <alpine.DEB.2.00.1008241256280.4763@router.home> <4C741029.7090300@cs.helsinki.fi> <alpine.DEB.2.00.1008241352240.5388@router.home> <4C74D1D7.4080608@kernel.org>
 <4C74DB05.7000101@cs.helsinki.fi> <alpine.DEB.2.00.1008250846590.13026@router.home> <4C762734.1030402@kernel.org> <4C8121A1.8060809@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reviewed-by: Christoph Lameter <cl@linux.com>

