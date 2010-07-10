Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab0GJG12 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 02:27:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53334 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab0GJG11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 02:27:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GvB9m/dGI44tRV2W6i5/juRJeShiVXgbi8zeu8s5a7hP9YPEAKkpimlctcWuCHYSgA
         52jxDISIG1xq8KEaKiUdD47JBfB/e40L55GAX3ly5G7a5reC4xmUJM5hpUmTgnNJ9KRy
         D9xxGmfIYswh9yTXD83NAD3c13V+pNv5mqgHA=
Subject: Re: net/sched/act_nat.c BUG
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Rodrigo Partearroyo =?ISO-8859-1?Q?Gonz=E1lez?= 
	<rpartearroyo@albentia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Iratxo Pichel Ortiz <ipichel@albentia.com>,
       Noelia =?ISO-8859-1?Q?Mor=F3n?= <nmoron@albentia.com>,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <20100709232359.GA2501@gondor.apana.org.au>
References: <201007091637.57660.rpartearroyo@albentia.com>
	 <1278688420.2696.7.camel@edumazet-laptop>
	 <20100709232359.GA2501@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Jul 2010 08:27:21 +0200
Message-ID: <1278743241.2538.28.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 10 juillet 2010 à 07:23 +0800, Herbert Xu a écrit :

> No we do need the second IP header, think about it...
> 
> However, we should only drop it only if it's long enough and
> pskb_may_pull fails.

Indeed right you are !

As Changli suggested, we need another pskb_may_pull() call.

Thanks


