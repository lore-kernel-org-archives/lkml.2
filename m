Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab1CVDKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 23:10:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60030 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1CVDKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 23:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=CLIy++jLlayrDTtwWKhCVtTKSxZlaMbhsDlJSN69CrVnGtPDAtkHvXT34xk6BsR6fe
         NflZPO3AIWY1f2rFcsIDmbrixY+HbD50UmT2D+mZGikfrayCfTee4CEQ5HA1ImfQ9mrP
         Km+ROjLNvTQ4CN6ONjGg9byIs6FuLkqNt5X30=
MIME-Version: 1.0
In-Reply-To: <20110322085755.c4193fc1.kamezawa.hiroyu@jp.fujitsu.com>
References: <1300452855-10194-1-git-send-email-namhyung@gmail.com>
	<20110322085755.c4193fc1.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 22 Mar 2011 08:40:51 +0530
X-Google-Sender-Auth: lIzCTFbimlfbQAZOlzgnvatfCh8
Message-ID: <AANLkTikN4j2EJr+HGXtPeRDph+rB6XXNNq13dYTDMhJU@mail.gmail.com>
Subject: Re: [PATCH 1/3] memcg: mark init_section_page_cgroup() properly
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 5:27 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 18 Mar 2011 21:54:13 +0900
> Namhyung Kim <namhyung@gmail.com> wrote:
>
>> The commit ca371c0d7e23 ("memcg: fix page_cgroup fatal error
>> in FLATMEM") removes call to alloc_bootmem() in the function
>> so that it can be marked as __meminit to reduce memory usage
>> when MEMORY_HOTPLUG=n.
>>
>> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
>> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
