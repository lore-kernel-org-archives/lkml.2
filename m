Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab1FOJ0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 05:26:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42898 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab1FOJ0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 05:26:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=jUdbt9EUwLTaIYy0c8WkOsFaxj6pr1ookXb87HhKbzOFJSIrCvHNQA2BMW92iGhHoq
         lbEdAzJ8W5FDyE2IQK+sv51SYTecJANuopYyPyLjc2tESnmX2RO9ARPORlASUxBM/Rch
         FGhDh9/zRLCNjsREn7dDi9YoHulrTiFC0z1bU=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Zach Pfeffer" <zach.pfeffer@linaro.org>, "Arnd Bergmann" <arnd@arndb.de>
Cc: "Daniel Stone" <daniels@collabora.com>, "Ankita Garg" <ankita@in.ibm.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Jesse Barker" <jesse.barker@linaro.org>, "Mel Gorman" <mel@csn.ul.ie>,
        linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, "Kyungmin Park" <kyungmin.park@samsung.com>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous Memory
 Allocator added
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>
 <20110614170158.GU2419@fooishbar.org>
 <BANLkTi=cJisuP8=_YSg4h-nsjGj3zsM7sg@mail.gmail.com>
 <201106142242.25157.arnd@arndb.de>
Date: Wed, 15 Jun 2011 11:26:47 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vw31uxxl3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <201106142242.25157.arnd@arndb.de>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jun 2011 22:42:24 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> * We still need to solve the same problem in case of IOMMU mappings
>   at some point, even if today's hardware doesn't have this combination.
>   It would be good to use the same solution for both.

I don't think I follow.  What does IOMMU has to do with CMA?

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
