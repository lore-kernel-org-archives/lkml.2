Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab1HWO0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 10:26:47 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:20340 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753256Ab1HWO0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 10:26:40 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: U0uCaVsVM1nB91hwCPFXnZtXNGHez7v8oHRJEJHD_fdorNm
 i3MvRCFIIdOhueH85PRXN1ZxNq9Gb0.DJoyRUcljN0BxA1IHttsyQbrRuUFm
 FRDDtPE43cD3rJgmzB7gO1v4E.Wi_7.KhWgZY9OXQhPZalPb103xV2botMt_
 y_heZeYv1CHXib1xvVEwS_06ps9SUbG3.Ake2MIgOqURop3NnY_XpbVwBxj2
 qUkU6td2aoXEdmkLvOmQQ9PDEJygapS4p.H3qhr.qJC3DEkYsWjH56T.SeDp
 .rA8cPaPdaKimZ8vvz1EmfoKwWiM2_7y2o4ofhgKaNGNQDarS3_TE2.ZzDKH
 xNiphhR73zQu3J_ZD.BtyThIypEAT4ZL6SuwusdFYDnGzdXUs3Q--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 23 Aug 2011 09:26:37 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Shaohua Li <shaohua.li@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>, penberg@kernel.org,
        "Shi, Alex" <alex.shi@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [patch 1/2]slub: add slab with one free object to partial list
 tail
In-Reply-To: <1314064098.29510.23.camel@sli10-conroe>
Message-ID: <alpine.DEB.2.00.1108230926150.21267@router.home>
References: <1314059819.29510.18.camel@sli10-conroe> <1314064098.29510.23.camel@sli10-conroe>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011, Shaohua Li wrote:

> Reported-by: Alex Shi <alex.shi@intel.com> Signed-off-by: Shaohua Li
> <shli@kernel.org> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Acked-by: Christoph Lameter <cl@linux.com>

