Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab1ATKBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 05:01:42 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50528 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab1ATKBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 05:01:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i1C3edNnGzFaNPL95lcpt36UfwAmoVRwk2JiB8JbSmRbRyS/cpCqDUO38NKV3wzGpt
         2WzhfM4onnCQ0z3LC6rmp8Fr39QgiLthuDCRjL8+4eOPE1IE1sRK5efP6Fb9rZUf6jbg
         tfDbUuxslTmOOM6WlXbmeF2s4KZxcl5DxyHFY=
MIME-Version: 1.0
In-Reply-To: <1294367707-2593-5-git-send-email-ddaney@caviumnetworks.com>
References: <1294367707-2593-1-git-send-email-ddaney@caviumnetworks.com>
	<1294367707-2593-5-git-send-email-ddaney@caviumnetworks.com>
Date: Thu, 20 Jan 2011 18:01:38 +0800
Message-ID: <AANLkTi=5+QxOipaTycLBuLUHr7iOGCe0nfG9mQsKADoj@mail.gmail.com>
Subject: Re: [PATCH 4/6] MIPS: perf: Reorganize contents of perf support files.
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Dezhong Diao <dediao@cisco.com>, Gabor Juhos <juhosg@openwrt.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/7 David Daney <ddaney@caviumnetworks.com>:
> @@ -1034,5 +1560,3 @@ init_hw_perf_events(void)
>        return 0;
>  }
>  arch_initcall(init_hw_perf_events);
> -
> -#endif /* defined(CONFIG_CPU_MIPS32)... */

arch_initcall should be now early_initcall.
