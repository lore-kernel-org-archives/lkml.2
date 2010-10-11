Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab0JKMwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 08:52:17 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:27718 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753920Ab0JKMwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 08:52:16 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: JVeTZsYVM1lYPpayr6ZRQGT5wfFuegZvVadiQLWH0rCW5F2
 8ddYUMgrqyasSZV5audLmNBap.q29wKq.24Mmbhh3lqLzY4Ygyu8ClZsFXDB
 Tqci.AEmh8TSWE3QM54hlinBK38KrFR6y1_h.dSNaFg1CKNNra16RBxSb1x9
 8mDSTHrOYcnhVl0K8U9UzCCe4SMngje9.EMcRtjCvzkeAJvEqM6VfwkYOZ2J
 ma0JelYWjM7tg0zObQe.ssgdHAO4-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 11 Oct 2010 07:52:12 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: pacman@kosh.dhis.org
cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: memory corrupting bug, bisected to 6dda9d55
In-Reply-To: <20101009095718.1775.qmail@kosh.dhis.org>
Message-ID: <alpine.DEB.2.00.1010110750390.6638@router.home>
References: <20101009095718.1775.qmail@kosh.dhis.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The contents of those scribbles may reveal something. Are these 4 bytes a
pointer? If so at what memory area are they pointing? A page struct?



