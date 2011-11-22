Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab1KVPtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:49:13 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:21480 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757372Ab1KVPtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:49:11 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: oOOkC0IVM1mffel.1juZNLf3uQViUqPRaLqLE_Ak3vaa.8R
 ORR86kjduDFZALDN4_jmTMbhms_cX8lwmVQ2yvMClTVfL0XxdnF3_SkEuVZn
 MiCSBf9Zqn66SPqd3jpBabd5VY0TYPhC1LeezzJC4bvkWDS46J9UKwE4rLoe
 PKlZbj89HsOFxe3eSSTKH.snbTwEz8pOdeHaFbwCvgkOZR208y4p_mJAJqg6
 Gpfll0ZnhyUPB0oM56O_vt5crpN_xB_CFf7.7x2RDL8U2ycba.GuUqh3_hDg
 uGruN3hrII7jpmBfn5B61t7H1qGJKC2Y.PsWTvj5tGpdB7YmftzD0Nvd4z.i
 6_t0shQga2O5AHIEdnjY_ZbA9CGQSsQxMvm1C8p6WYksH6VTuaLbFvtPSi3J
 Yug7WCZxBmHuTO4t4kDVNaw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 Nov 2011 09:49:08 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [RFC, PATCH] slub: unfreeze_partials() uses a wrong param
In-Reply-To: <1321976189.2474.35.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1111220948240.25785@router.home>
References: <1321976189.2474.35.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Eric Dumazet wrote:

> unfreeze_partials() calls add_partial(..., 1) while it should use
> DEACTIVATE_TO_TAIL or DEACTIVATE_TO_HEAD

Something like that must already be pending in Pekka's tree. I have seen
this patch a couple of times before.
