Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab1EYPYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:24:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33450 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756959Ab1EYPYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:24:38 -0400
Message-ID: <4DDD1F34.7030702@suse.cz>
Date: Wed, 25 May 2011 17:24:36 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Thomas Sailer <t.sailer@alumni.ethz.ch>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-hams@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH 17/34] hdlcdrv: Drop __TIME__ usage
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>	 <1302015561-21047-18-git-send-email-mmarek@suse.cz> <1302015790.4124.54.camel@xbox360.hq.axsem.com>
In-Reply-To: <1302015790.4124.54.camel@xbox360.hq.axsem.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5.4.2011 17:03, Thomas Sailer wrote:
> On Tue, 2011-04-05 at 16:59 +0200, Michal Marek wrote:
>> The kernel already prints its build timestamp during boot, no need to
>> repeat it in random drivers and produce different object files each
>> time.
>>
>> Cc: Thomas Sailer<t.sailer@alumni.ethz.ch>
>> Cc: linux-hams@vger.kernel.org
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Michal Marek<mmarek@suse.cz>
> Acked-By: Thomas Sailer<t.sailer@alumni.ethz.ch>
>
> Ok with me

I didn't find the commit in today's linux-next, so I applied this to
kbuild-2.6.git#trivial.

Michal
