Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab1GSOBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 10:01:36 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:33489 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751001Ab1GSOBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 10:01:35 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 3vbXeUkVM1l0u.guhY.aOjjwoxYp6fJMwU2Fown4YzJJs.v
 FNbvD8zEp9FYwNdNgzo7Jt.py3YINHC.Q78DX6FiscmyMQkqvpXyrKpLd_YH
 wHPa68nBrS23FI07eeGfWbNrT9vOuEbn6YCFwsU4_CRusVMgLgCHQqaUlxp6
 1f0SoDJtXSs3cT40EXhqTbM.9TwDKZT.beQ5Uu6au9b3lWlnYA6GbBbrx4Xn
 YknDxTDMgw64rzrzjDtG7p8f.PL_2gzS_tKgPUJMSU5MFQVUQJaXJv1xpQ_2
 I9UvhSv8S21FfSv3ZC254m9Zxu2d._3mUaj8rUoc9bflSEcUeznOfGT.jihC
 QoNWp6mJyTscjIQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 19 Jul 2011 09:01:32 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: page allocator: Initialise ZLC for first zone
 eligible for zone_reclaim
In-Reply-To: <alpine.DEB.2.00.1107181651000.31576@router.home>
Message-ID: <alpine.DEB.2.00.1107190901120.1199@router.home>
References: <1310742540-22780-1-git-send-email-mgorman@suse.de> <1310742540-22780-2-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1107180951390.30392@router.home> <20110718160552.GB5349@suse.de> <alpine.DEB.2.00.1107181208050.31576@router.home>
 <20110718211325.GC5349@suse.de> <alpine.DEB.2.00.1107181651000.31576@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well we can unwind that complexity later I guess.

Reviewed-by: Christoph Lameter <cl@linux.com>

