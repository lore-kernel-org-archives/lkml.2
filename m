Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab0HWMsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 08:48:04 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:22259 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751397Ab0HWMsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 08:48:03 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 91AdvG0VM1kSor_xFlQ8_V_Ag2nkx3iV4U2xaaOxIz190u8
 GBewFK1u3uNl7smG6Jk6_cDz.eWTaO48Mo74yCN0GnIlkd8fnF5N9llaEwXM
 hvoVFmOkRdH_3gxyhKyCyhpk1IEcLol.OKas_b8FNhDgeKvO.M6QcdB8utoH
 L9_bgcgv7zRb4Tx5QYMRGYX71Z97LpN3.6k9TyAV8YFvqsc6VNi4QKFHuiS5
 UMlTf1GhL81Jtqjjemxo8df8QBr9I1Ms.oifsGz3YP1lr_ajEBSYG55IJG5F
 JDNWkHQ--
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 23 Aug 2010 07:47:18 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/3] mm: page allocator: Update free page counters after
 pages are placed on the free list
In-Reply-To: <1282550442-15193-2-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1008230747020.4094@router.home>
References: <1282550442-15193-1-git-send-email-mel@csn.ul.ie> <1282550442-15193-2-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reviewed-by: Christoph Lameter <cl@linux.com>


