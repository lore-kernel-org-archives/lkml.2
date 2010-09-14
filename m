Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab0INS7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 14:59:47 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:29309 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753840Ab0INS7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 14:59:46 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: i9wjkR0VM1ky3EOkOBbm1RplZaDfUp0n4PJ0zvu78b3BpRu
 lukjM.cPDvD04IfDlaT7fnbDtifdx03GgzlxgKe6Z803EKiMdeACBxIQBC3R
 aGzNDzTdpC6BM41cDSd3aHRHXO68SvEXtZKUO2YTARB6BPHmp75zbEBUOehq
 wE.m7znLmaHJDEIgIlpKBqHVc2vZhq6s6lYco.IW7M2sV._TMwtm8HqP3bwz
 qI_A.Wzn3m6vvQ0v8bhvP0ImEM23lo99Z_M3ULCqYBv0K4O3grbZwzOPaE_G
 zzQ--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 14 Sep 2010 13:59:43 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2 1/2] SLUB: Fix merged slab cache names
In-Reply-To: <1284490101-2362-1-git-send-email-penberg@kernel.org>
Message-ID: <alpine.DEB.2.00.1009141357160.444@router.home>
References: <1284490101-2362-1-git-send-email-penberg@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010, Pekka Enberg wrote:

> @@ -3211,6 +3225,7 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
>  		size_t align, unsigned long flags, void (*ctor)(void *))
>  {
>  	struct kmem_cache *s;
> +	char *dup_name;

Dont like the name. Its a short lived variables. So "n"?

Otherwise

Acked-by: Christoph Lameter <cl@linux.com>

