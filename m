Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0GZKYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 06:24:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44450 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab0GZKYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 06:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=K+NSj4Frkf5EU1GPwfRr82QJarBPPhzFJGSgB6lGGEelJgKqljpIPLSvHDuevU4wiV
         2eTF7jww5ISUsI5hI7FrMspKuxS5r8r9KGy+Y7moJXRs2fII68Cb1A36eCnZMCQNQkbO
         Py5C1fTTAQA3agjjCpRNXro/1sfufWLha17yM=
MIME-Version: 1.0
In-Reply-To: <20100726120224.2EF1.A69D9226@jp.fujitsu.com>
References: <20100726120107.2EEE.A69D9226@jp.fujitsu.com>
	<20100726120224.2EF1.A69D9226@jp.fujitsu.com>
Date: Mon, 26 Jul 2010 15:54:06 +0530
X-Google-Sender-Auth: eT-JWnZjVEijbI2NBzepu5V-vEg
Message-ID: <AANLkTi=Eou4UVgYN2JY_AWnCj+Lcbv6MkMmUpn94SRYK@mail.gmail.com>
Subject: Re: [PATCH 1/4] vmscan: convert direct reclaim tracepoint to 
	DEFINE_TRACE
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

On Mon, Jul 26, 2010 at 8:33 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Mel Gorman recently added some vmscan tracepoints. Unfortunately they are
> covered only global reclaim. But we want to trace memcg reclaim too.
>
> Thus, this patch convert them to DEFINE_TRACE macro. it help to reuse
> tracepoint definition for other similar usage (i.e. memcg).
> This patch have no functionally change.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Mel Gorman <mel@csn.ul.ie>

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Balbir
