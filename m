Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab2EJPlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:41:50 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:38605 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751386Ab2EJPlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:41:47 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: LTa773gVM1lIIMZXylHpcu25orQyST67bzdx7aVX8rXFh_x
 SON_yea.ejR8blM53v6avLJMb3Q1S6wbeY.gOjGZgeY2eZO17CILtOW1JV74
 c4b6W9CqhUxlf.RhEr8heFtgb2oTar0V4ew.1NRfja5hM7JfWzY_DbVK5jMr
 z4BqMtN3OUP1IOYOhxc2U2yxG4GsOavAGp8Rt0rQPENDTv6M099osSGPAWdD
 O2jpwRu2FgoBa3auyz1xeTdI5P2WZA77..CS4eL56a8ys74qPbu5wjyUMibm
 q7JE.VYoVNP_boB926YTm7qsTB98rXAWIOCa70oBxWRRnCzSRTXn_5KRu8gg
 hSqSwTNZqypgVvpQU.VES70KZX.TKAtEhER2y4ZG.AEF.ik4w8_pa5.AXaXe
 Vlci86La6zCFNcNd3CI_LuuTo7MDT3e84YeE-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 10 May 2012 10:41:44 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] slub: fix a possible memory leak
In-Reply-To: <1336663979-2611-1-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1205101041300.18664@router.home>
References: <1336663979-2611-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Joonsoo Kim wrote:

> Memory allocated by kstrdup should be freed,
> when kmalloc(kmem_size, GFP_KERNEL) is failed.

True.

Acked-by: Christoph Lameter <cl@linux.com>
