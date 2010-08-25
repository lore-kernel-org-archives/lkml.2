Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab0HYAZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:25:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32847 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab0HYAZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:25:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=on5NDC5Rk67TA3Wft/jOHtlwX/zGI280lpkSDJTE0G6xtggSP/OeN7Kqu+pO6T/fPj
         qqu5EbCf1TVkbGLeonAw==
MIME-Version: 1.0
In-Reply-To: <20100825091747.f6ea9e0e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100820185816.1dbcd53a.kamezawa.hiroyu@jp.fujitsu.com>
	<4C738B34.6070602@cn.fujitsu.com>
	<AANLkTi=HwPeWafzTBh66g37XxZouKicsemmnTE-Cvz=Y@mail.gmail.com>
	<20100825091747.f6ea9e0e.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 24 Aug 2010 17:25:30 -0700
Message-ID: <AANLkTi=e9NfdQSTHk2DFEPWT3uVEnQAreCZPpRDFjxgC@mail.gmail.com>
Subject: Re: [PATCH 1/5] cgroup: ID notification call back
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 5:17 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> Hmm, then, should I remove it in the next version, or leave it as it is
> now and should be removed by another total clean up ?

I think these are two separate issues. A cleanup to remove the ss
parameters from the existing callback methods would be separate from
your proposed id callback, which I think is better done (as I
mentioned above) by passing the id to create()

Paul
