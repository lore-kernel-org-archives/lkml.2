Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab0KRPoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:44:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab0KRPoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:44:15 -0500
Date: Thu, 18 Nov 2010 16:37:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, akinobu.mita@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpu.c: remove unused variable
Message-ID: <20101118153726.GA587@redhat.com>
References: <1290091494.1145.5.camel@gondor.retis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290091494.1145.5.camel@gondor.retis>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18, Dhaval Giani wrote:
>
> --- linux-2.6.orig/kernel/cpu.c
> +++ linux-2.6/kernel/cpu.c
> @@ -197,7 +197,6 @@ struct take_cpu_down_param {
>  static int __ref take_cpu_down(void *_param)
>  {
>  	struct take_cpu_down_param *param = _param;
> -	unsigned int cpu = (unsigned long)param->hcpu;
>  	int err;

This is on top of Peter's patch, I guess.

Agreed, it looks unused.

Oleg.

