Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1DCSiG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 14:38:06 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:25081 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752974Ab1DCSiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 14:38:04 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 9al2z_cVM1lQksr0ShXMkEq6kCcbh_Gn20e19KtgWb0sEYr
 .La5oFF7OEND1Ex_gtfzpbScoTDkddUqe102u0Q7QTsjjysPw_ksx2WEMh_b
 ..1v6i4fcYbYpRDYOzhmh9YvRTEbO14GsBCGkA25d9h.Vgsn97K2XRS1kXS.
 M.2sSP5wjSKAaT_ZRYHI0SR2HddbpWF_sKyFxei1DdfULkvUFNvdcTUdeOIs
 06c.aIeGvjElZIE5udlhQRs1Jg_XW5rhdzeV2I4W.XOa2w37EjI40m7s4Yci
 rjMnb9r7D3SmvpjYbA1N012p07YfUsJQFCb_bOicGHgvdtCPLXbM129brGuj
 Xz9Ft5Hqn46Vw4DKqXdym5C8U
X-Yahoo-Newman-Property: ymail-3
Date: Sun, 3 Apr 2011 13:38:01 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: kernel BUG at mm/slub.c:1193!
In-Reply-To: <201104012359.58676.johannes.hirte@fem.tu-ilmenau.de>
Message-ID: <alpine.DEB.2.00.1104031336250.15317@router.home>
References: <201104012053.30458.johannes.hirte@fem.tu-ilmenau.de> <alpine.DEB.2.00.1104011625550.27326@router.home> <201104012359.58676.johannes.hirte@fem.tu-ilmenau.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Apr 2011, Johannes Hirte wrote:

> On Friday 01 April 2011 23:28:02 Christoph Lameter wrote:
> > Which kernel version is this? Line 1193 in upstream is not in the function
> > new_slab(). If this is the BUG_ON in new_slab() then we have an issue with
> > illegal flags being passed to kmem_cache_alloc().
>
> As the Oops says, it is 2.6.38.1. This is the BUG_ON in new_slab().

Well you need to talk to the one who wrote the passed illegal flags to
kmem_cache_alloc. Would be helpful to know which flags were passed.

