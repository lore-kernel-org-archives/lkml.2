Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2HAPGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:06:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155Ab2HAPGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:06:46 -0400
Message-ID: <501945F9.2030402@redhat.com>
Date: Wed, 01 Aug 2012 11:06:33 -0400
From: Larry Woodman <lwoodman@redhat.com>
Reply-To: lwoodman@redhat.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Thunderbird/3.1.7
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, Linux-MM <linux-mm@kvack.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Ken Chen <kenchen@google.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -alternative] mm: hugetlbfs: Close race during teardown
 of hugetlbfs shared page tables V2 (resend)
References: <alpine.LSU.2.00.1207222033030.6810@eggly.anvils> <50118E7F.8000609@redhat.com> <50120FA8.20409@redhat.com> <20120727102356.GD612@suse.de> <5016DC5F.7030604@redhat.com> <20120731124650.GO612@suse.de> <50181AA1.0@redhat.com> <20120731200650.GB19524@tiehlicka.suse.cz> <50189857.4000501@redhat.com> <20120801082036.GC4436@tiehlicka.suse.cz> <20120801123209.GK4436@tiehlicka.suse.cz>
In-Reply-To: <20120801123209.GK4436@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 08:32 AM, Michal Hocko wrote:
>
> I am really lame :/. The previous patch is wrong as well for goto out
> branch. The updated patch as follows:
This patch worked fine Michal!  You and Mel can duke it out over who's 
is best. :)

Larry

