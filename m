Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab1CVDNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 23:13:12 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:59685 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab1CVDNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 23:13:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=aKbQxetPeTxieG54rERefImOUucleIkCTuIw9MOWso1/kt4FyUxsX2WhPYxYHaOHoF
         r+J7vMOQMESzpuEUk2wauay4tQV2Jps50OG8V8NQ+ksr9xq4TsGHDRo/cSmZoiP3OCUU
         Id4XC6nMkozJngymoXY7p5ANM4pmZYeARZ+WU=
MIME-Version: 1.0
In-Reply-To: <20110322085844.31041d40.kamezawa.hiroyu@jp.fujitsu.com>
References: <1300452855-10194-1-git-send-email-namhyung@gmail.com>
	<1300452855-10194-2-git-send-email-namhyung@gmail.com>
	<20110322085844.31041d40.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 22 Mar 2011 08:43:08 +0530
X-Google-Sender-Auth: p52Qib1I8ZokpQihoEQSCFfX-KA
Message-ID: <AANLkTikDXLtGXmya72UL_hU2prKtaO3fNJ-ZpxssXXzJ@mail.gmail.com>
Subject: Re: [PATCH 2/3] memcg: fix off-by-one when calculating swap cgroup
 map length
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 5:28 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 18 Mar 2011 21:54:14 +0900
> Namhyung Kim <namhyung@gmail.com> wrote:
>
>> It allocated one more page than necessary if @max_pages was
>> a multiple of SC_PER_PAGE.
>>
>> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
>> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
