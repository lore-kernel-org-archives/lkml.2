Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab1GZSbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:31:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab1GZSba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:31:30 -0400
Message-ID: <4E2F08A0.5080704@suse.cz>
Date: Tue, 26 Jul 2011 20:34:08 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kbuild@vger.kernel.org, lacombar@gmail.com, sam@ravnborg.org,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 2/2] mm: Switch NUMA_BUILD and COMPACTION_BUILD to
 new KCONFIG() syntax
References: <4E1D9C25.8080300@suse.cz> <1311634718-32588-1-git-send-email-mmarek@suse.cz> <1311634718-32588-2-git-send-email-mmarek@suse.cz> <20110726151908.GD17958@tiehlicka.suse.cz>
In-Reply-To: <20110726151908.GD17958@tiehlicka.suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 26.7.2011 17:19, Michal Hocko napsal(a):
> On Tue 26-07-11 00:58:38, Michal Marek wrote:
>> Cc: linux-mm@kvack.org
>> Signed-off-by: Michal Marek <mmarek@suse.cz>
> 
> I assume that this is a cleanup. Without seeing the rest of the patch
> set (probably not in linux-mm missing in the CC) and the cover email it
> is hard to be sure. Could you add some description to the patch, please?

Sorry for the confusion. Patch 1/2 is here:
https://lkml.org/lkml/2011/7/25/448 and provides a generic way to use
CONFIG_* options in C expressions. This patch 2/2 for demonstration
purposes only, if the first patch hits mainline, then I'll submit this
one properly.

Michal
