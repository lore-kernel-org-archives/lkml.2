Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab0K3TK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:10:27 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:45898 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754250Ab0K3TKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:10:23 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: w9ULTOoVM1k0xa6ldBR31i.mkEVDwdrMce.4qCCtFIln_tu
 13V2TEi07g36MKbjg.500SUglDHn.CVFpOCWehjxNz2T8D5phqwR6iLFG7vU
 3TP0xLUlVFE5huOuN9to9GrnT2iPA0b_.tbsHBv2RxGikig_Sj_mZH9WDuB3
 6sSlVXookSSt8DJRCRLcyy1JZTFWKaQDyJ77KRqIWnn8HK9J7x5u2OSrA3Vd
 TVDYMNMImy2s-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 30 Nov 2010 13:10:19 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Simon Kirby <sim@hostway.ca>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: Free memory never fully used, swapping
In-Reply-To: <20101130092534.82D5.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1011301309240.3134@router.home>
References: <20101125101803.F450.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011260943220.12265@router.home> <20101130092534.82D5.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, KOSAKI Motohiro wrote:

> This?

Specifying a parameter to temporarily override to see if this has the
effect is ok. But this has worked for years now. There must be something
else going with with reclaim that causes these issues now.
