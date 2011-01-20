Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab1ATJiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 04:38:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:53996 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171Ab1ATJiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 04:38:03 -0500
Message-ID: <4D380279.4070502@suse.cz>
Date: Thu, 20 Jan 2011 10:38:01 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        tapio.vihuri@nokia.com
Subject: Re: Checkpatch problem with Kconfig help symbol ?
References: <1295440968.2276.46.camel@dell> <ih8qf2$41t$3@dough.gmane.org>
In-Reply-To: <ih8qf2$41t$3@dough.gmane.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.1.2011 09:06, WANG Cong wrote:
> On Wed, 19 Jan 2011 14:42:48 +0200, Tapio Vihuri wrote:
> 
>> Hi
>>
>> Is this false positive ?
>>
>> WARNING: please write a paragraph that describes the config symbol fully
>> #60: FILE: drivers/input/misc/Kconfig:159: +       help
>>
>>
>> Interesting enough, also:
>>
>> ./scripts/checkpatch.pl --file drivers/input/misc/Kconfig WARNING:
>> please write a paragraph that describes the config symbol fully #430:
>> FILE: input/misc/Kconfig:430:
>> +       help
>>
>>
>> But this is different line.
>>
> 
> Seems yes, the Kconfig part of your patch looks fine.

The check is complaining that the help text is too short:

+config ECI_CTRL_DEBUG
+	bool "ECI controller debug"
+	depends on INPUT_ECI_AT20
+	help
+	  Say Y here to enable debugging messages for ECI controller driver.

Michal
