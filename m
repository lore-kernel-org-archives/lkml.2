Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab2A3QPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:15:24 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:48453 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753903Ab2A3QPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:15:22 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: BMtuoVMVM1lqMfcd0fQ15XRRu.OaSromMNvL.doO4v5EHVC
 _I_8V4dQsY1ME1Z4hRGNH4GTp1_nSEGAYJcRWUrZUFKUAbRfhOSsMAOMuNhw
 jDLqddSDWnZo7iD3FDk7MtoEc8IpJMX7moLes6TpfLcd00Npnl8pzFP5JMna
 J7cXwq.phKmDfoecb.Ql2x3axEsiEREwleL8UPdVC8uih2e6gq1dViIfABEZ
 9z2PYInaWs_XUopju.JH.ev074lOZk3tR6XC79nwTr4askAvaBqZe.sA4I8K
 Ec868KFha8ghsWFn5hzQVPBxLoS.BRNLl2T2dpDyFUhBAScEvU1FB.2u06ts
 j5EbT9WcV7QM7L_Q.pQLrIBnMPrdAv3uvlBS0ZTMj44VrYCoyw3Bsucy8qtR
 _VQxBzwnGRH0A8z7m9jS3AV5qt_QQv3lCrdFHBdKZ
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 30 Jan 2012 10:15:18 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dmitry Antipov <dmitry.antipov@linaro.org>
cc: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/3] percpu: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
In-Reply-To: <1327912654-8738-1-git-send-email-dmitry.antipov@linaro.org>
Message-ID: <alpine.DEB.2.00.1201301006140.28693@router.home>
References: <1327912654-8738-1-git-send-email-dmitry.antipov@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012, Dmitry Antipov wrote:

> Fix pcpu_alloc() to return ZERO_SIZE_PTR if requested size is 0;
> fix free_percpu() to check passed pointer with ZERO_OR_NULL_PTR.

Acked-by: Christoph Lameter <cl@linux.com>
