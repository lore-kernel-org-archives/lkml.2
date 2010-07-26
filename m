Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab0GZKXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 06:23:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63804 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab0GZKXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 06:23:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=f04HUfP239pSZWDg5sjtXLMMoD2VcZSo4wJ8FkSBEPcespahCcfGI7NgI9KeKzqSBo
         HlaHT7jxCECqsqznfjfuIKQzoU/XHIrDqK8CD/pIyZPjvvjI3qrZoOb3eEY6kk+car6b
         UUZqiQsrQwQMQ1y2uDTpaGHpFpJjQqvCpY/jw=
MIME-Version: 1.0
In-Reply-To: <20100726120107.2EEE.A69D9226@jp.fujitsu.com>
References: <20100726120107.2EEE.A69D9226@jp.fujitsu.com>
Date: Mon, 26 Jul 2010 15:53:13 +0530
X-Google-Sender-Auth: AOT-cXGhAyGUq2jtQbdOaijwMVg
Message-ID: <AANLkTi=sVdkkHm8wvjRC4gQUjsKBm1TiLfvxvVBEbbAn@mail.gmail.com>
Subject: Re: [PATCH 0/4] memcg reclaim tracepoint v2
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 8:32 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>
> Recently, Mel Gorman added some vmscan tracepoint. but they can't
> trace memcg. So, This patch series does.
>

The overall series looks good to me, acking the approach and the need
for these patches

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
