Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab0HSIhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 04:37:19 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:61961 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751315Ab0HSIhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 04:37:17 -0400
X-IronPort-AV: E=Sophos;i="4.56,232,1280700000"; 
   d="scan'208";a="57545555"
Message-ID: <4C6CED3B.3050709@inria.fr>
Date: Thu, 19 Aug 2010 10:37:15 +0200
From: Tomasz Buchert <tomasz.buchert@inria.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] cgroup_freezer: Freezing and task move race fix
References: <1281470001-14320-1-git-send-email-tomasz.buchert@inria.fr> <20100810215741.GC2927@count0.beaverton.ibm.com> <4C61D044.2060703@inria.fr> <20100811042738.GH2927@count0.beaverton.ibm.com> <4C6252CF.1090100@inria.fr> <20100812002154.GJ2927@count0.beaverton.ibm.com> <4C634605.50301@inria.fr> <20100812201334.GA29096@count0.beaverton.ibm.com> <4C6B339E.6010907@inria.fr> <20100818022210.GH3648@count0.beaverton.ibm.com>
In-Reply-To: <20100818022210.GH3648@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 18/08/2010 04:22, Matt Helsley a écrit :
> On Wed, Aug 18, 2010 at 03:13:02AM +0200, Tomasz Buchert wrote:
>> Le 12/08/2010 22:13, Matt Helsley a écrit :
>
> <snip>
>
>>
>> Matt,
>> Am I supposed to do something right now? The discussion
>> became a bit quiet recently.
>>
>> Cheers,
>> Tomasz
>
> Hi Tomasz,
>
> 	I'm sorry. I haven't had much time to review your latest
> patches and comment. I thought Andrew put them in his -mm tree
> so I don't think you have anything to do at the moment.
>
> Cheers,
> 	-Matt

Take your time, Matt. I only wish that eventually the problem will be 
fixed, that or another way.

Tomek
