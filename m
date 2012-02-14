Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959Ab2BNPDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 10:03:43 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:45933 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756682Ab2BNPDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 10:03:39 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: dg7GTOkVM1mrKUP9NPLJ41a0QimJlixzmGgY8eBVN0kTzjP
 641jcd4McUQ1srKI432jNzFybF6WzmthPvRkfnxJ0Blj0RDDW39wyo5fi1D_
 qR8lW2FxlxovN0B3cdneA2m6CwVdCnBDWkmftUZrYNY6CvhSfJiKD.vPkD1I
 ZI5AZA3LFDeGgSb58BEt8zAXUbhh9ll92gjctYNX8mvcl01_jpM56Pu_5jan
 iP_9rwI3cvlhw_EGGatIhCV82lXj37OhukMFVIqruTj6APjTM38WVK8eO7EF
 bI.RJxlJi0mhjB7QKRGRY931eKrpsHHd_ChZu5hm.Iz4IBeRx8hSPiqy8mBQ
 mbSOva9RFp0pRjs9Kp0A6HsY.UVBYjsBXVZYCLVvsWUKny8S3wSULSqABtLO
 ebDRsKojEWKo5D5WMRC_LtCc5SwBkgbgH9emN
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 14 Feb 2012 09:03:36 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Yang Bai <hamo.by@gmail.com>
cc: penberg@kernel.org, mpm@selenic.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: warning if total alloc size overflow
In-Reply-To: <1329204499-2671-1-git-send-email-hamo.by@gmail.com>
Message-ID: <alpine.DEB.2.00.1202140902400.20013@router.home>
References: <1329204499-2671-1-git-send-email-hamo.by@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012, Yang Bai wrote:

> Before, if the total alloc size is overflow,
> we just return NULL like alloc fail. But they
> are two different type problems. The former looks
> more like a programming problem. So add a warning
> here.

Acked-by: Christoph Lameter <cl@linux.com>

Would be better to remove kcalloc and provide a generalized array size
calculation function that does the WARN(). That would also work for all
other variants zeroed or NUMA node spec etc etc.
