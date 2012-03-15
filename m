Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761444Ab2COLXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:23:00 -0400
Received: from mx2.parallels.com ([64.131.90.16]:56768 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761341Ab2COLW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:22:56 -0400
Message-ID: <4F61D0B3.8000300@parallels.com>
Date: Thu, 15 Mar 2012 15:21:23 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Suleiman Souhlal <ssouhlal@FreeBSD.org>, <cgroups@vger.kernel.org>,
        <suleiman@google.com>, <penberg@kernel.org>, <cl@linux.com>,
        <yinghan@google.com>, <hughd@google.com>, <gthelen@google.com>,
        <dan.magenheimer@oracle.com>, <hannes@cmpxchg.org>, <mgorman@suse.de>,
        <James.Bottomley@HansenPartnership.com>, <linux-mm@kvack.org>,
        <devel@openvz.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/13] memcg: Kernel memory accounting infrastructure.
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org>  <1331325556-16447-3-git-send-email-ssouhlal@FreeBSD.org>  <4F5C5E54.2020408@parallels.com>  <20120313152446.28b0d696.kamezawa.hiroyu@jp.fujitsu.com>  <4F5F236A.1070609@parallels.com>  <20120314091526.3c079693.kamezawa.hiroyu@jp.fujitsu.com>  <4F608F25.3010700@parallels.com> <4F613C5B.8030304@jp.fujitsu.com>  <4F61CD63.4090007@parallels.com> <1331810014.18960.172.camel@twins>
In-Reply-To: <1331810014.18960.172.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.255.67.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 03:13 PM, Peter Zijlstra wrote:
> On Thu, 2012-03-15 at 15:07 +0400, Glauber Costa wrote:
>> But since I never heard of any machine with
>> 9223372036854775807 bytes of memory, that is true even for the root memcg
>
> What, you don't have more than 8 exabyte of memory in your laptop !?
> Surely you're due for an upgrade then.

Yeah, I requested it already, but I was told it could take a while
