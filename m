Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab1EZJIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 05:08:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54803 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab1EZJI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 05:08:29 -0400
Message-ID: <4DDE1891.8090101@suse.cz>
Date: Thu, 26 May 2011 11:08:33 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com
Subject: Re: [PATCH 27/34] gfs2: Drop __TIME__ usage
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>	 <1302015561-21047-28-git-send-email-mmarek@suse.cz>	 <4DDD6B1F.1060303@suse.cz> <1306399434.2893.2.camel@menhir>
In-Reply-To: <1306399434.2893.2.camel@menhir>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.5.2011 10:43, Steven Whitehouse wrote:
>> I don't see this patch in today's linux-next. Any objection against me
>> applying it to the kbuild-2.6.git repository?
>>
> No, I think that should be ok. It was added as a method to spot when
> someone had compiled their own module against a distro kernel, but tbh
> this isn't a problem in practice, so I don't think it will be a problem,

OK, thanks. Applied to kbuild-2.6.git#trivial.

Michal
