Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab1CWHcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 03:32:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:49088 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab1CWHcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 03:32:41 -0400
Message-ID: <4D89A20E.3020604@suse.cz>
Date: Wed, 23 Mar 2011 08:32:30 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, greg@kroah.com, joe@perches.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH]Clean up CodingStyle for scripts/kconfig/gconf.c
References: <20110322143839.GA10291@gmail.com> <4D894CD0.9030509@cn.fujitsu.com>
In-Reply-To: <4D894CD0.9030509@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.3.2011 02:28, Li Zefan wrote:
> Harry Wei wrote:
>> Hi us,
>>    	Clean up CodingStyle for scripts/kconfig/gconf.c.
>>
> 
> What makes you think this is a bad style? Does Documentation/CodingStyle say
> so? Does checkpatch.pl make a complain? Do you really think this improves
> readability? I don't think so, and actually it makes the code worse.

This include can be removed completely, there is no config.h in kconfig.

Michal
