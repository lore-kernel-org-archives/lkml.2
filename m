Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab0LBOkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 09:40:00 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:42011 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757445Ab0LBOj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 09:39:59 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Yn1bH8kVM1k9gnTDlXUTI8aHHfR7BRrPg7GpKbl9fTkIDgG
 fsCnfXscfovIfEjXvNnzRaUcAb.D0wn_KXjDMYAgfROet61BTXtfoxEYvKaY
 sk6Ddlz0o6wWTqoPpZjGpL5ts35mPfskSpiSYqas3bvhnDW2CQVyvjToaPuI
 Un1yIROpEE21AVZqsX7fpK8rVT_ZdqLBpnWlR7HJ7qd3DYlIz17ktRTG3ivP
 TU_uLULiXGPxREgmfG4lRkgohDAbmm1lUy9Qic4E-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 2 Dec 2010 08:39:55 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Simon Kirby <sim@hostway.ca>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: Free memory never fully used, swapping
In-Reply-To: <20101202093337.1573.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1012020836590.27798@router.home>
References: <20101201114226.ABAB.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1012010910450.2989@router.home> <20101202093337.1573.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Dec 2010, KOSAKI Motohiro wrote:

> So I think we have multiple option
>
> 1) reduce slub_max_order and slub only use safely order
> 2) slub don't invoke reclaim when high order tryal allocation
>    (ie turn off GFP_WAIT and turn on GFP_NOKSWAPD)
> 3) slub pass new hint to reclaim and reclaim don't work so aggressively if
>    such hint is passwd.
>
>
> So I have one question. I thought (2) is most nature. but now slub doesn't.

2) so far has not been available. GFP_NOKSWAPD does not exist upstream.

