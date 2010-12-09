Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab0LIBnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 20:43:45 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53698 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab0LIBno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 20:43:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NhEYvh5t0O7QacyUOJ4BegzRO0AksHcCrWJqGjCy9FdPa+2+adVb5JwYvaFh7YUph3
         5GQzEwW/Qqr8XgGNcrmO7VpOtF82s/TKC+q1uciGOK8QKaE3ohSNNyhupeHGQNSip8Wt
         U3DF7WLjRIPPRN64J4CekByWa7u2InJmq8v84=
Subject: Re: [tip:sched/core] printk: Use this_cpu_{read|write} api on
 printk_pending
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1012081546170.28112@router.home>
References: <1290788536.2855.237.camel@edumazet-laptop>
	 <tip-40dc11ffb35e8c4e8fa71092048e0f8de9db758c@git.kernel.org>
	 <alpine.DEB.2.00.1012081546170.28112@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 02:43:39 +0100
Message-ID: <1291859019.2795.20.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 08 décembre 2010 à 15:47 -0600, Christoph Lameter a écrit :
> On Wed, 8 Dec 2010, tip-bot for Eric Dumazet wrote:
> 
> > printk: Use this_cpu_{read|write} api on printk_pending
> 
> One of the patches in Tejun's percpu tree includes the same modifications.
> 
> 

Its a bit strange, I sent mine a long time ago when reviewing Heiko
Carstens patch. You even commented on it.

https://patchwork.kernel.org/patch/359182/

What happened then, you included my patch on one of yours ?



