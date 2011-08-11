Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab1HKNMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:12:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829Ab1HKNMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:12:47 -0400
Message-ID: <4E43D54D.8030202@suse.cz>
Date: Thu, 11 Aug 2011 15:12:45 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Switch NUMA_BUILD and COMPACTION_BUILD to new IS_ENABLED()
 syntax
References: <1312989160-737-1-git-send-email-mmarek@suse.cz> <20110811125133.GJ8023@tiehlicka.suse.cz> <20110811130110.GK8023@tiehlicka.suse.cz>
In-Reply-To: <20110811130110.GK8023@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.8.2011 15:01, Michal Hocko wrote:
> On Thu 11-08-11 14:51:33, Michal Hocko wrote:
>> On Wed 10-08-11 17:12:40, Michal Marek wrote:
>>> Introduced in 3.1-rc1, IS_ENABLED(CONFIG_NUMA) expands to a true value
>>> iff CONFIG_NUMA is set. This makes it easier to grep for code that
>>> depends on CONFIG_NUMA.
> 
> I have just looked closer at all available macros. Wouldn't it make more
> sense to use IS_BUILTIN instead? Both symbols can be only on or off.
> Not that it would make any difference in the end. I even like IS_ENABLED
> naming more.

IS_ENABLED() and IS_BUILTIN() are equivalent for boolean symbols.
IS_BUILTIN() and IS_MODULE() are meant for the (rare) case when someone
needs to distinguish between built in and module for tristate options in
the code.

Michal
