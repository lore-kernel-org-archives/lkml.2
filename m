Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1EUHqG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 03:46:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56564 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab1EUHqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 03:46:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=I2ZWwymdoUl24/Z7ZuvELaxDD0ifjPkzTZBGV/if5YQWStwAf8necH+vel8qGzF5sg
         p35DgeLdetGSOzw9WaUfskm+U/kbLA4ElJdXxavVYYyr7jrx+FgXE7VKLv4AHSYHjrxk
         HV2XW9rebLQ2EQo2KVaA2f3lP5fWiUXh9gTOY=
Message-ID: <4DD76DB7.3030708@gmail.com>
Date: Sat, 21 May 2011 11:45:59 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, steiner@sgi.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86, apic: apicdriver probe cleanups - V2
References: <20110521005116.136357574@sbsiddha-MOBL3.sc.intel.com>
In-Reply-To: <20110521005116.136357574@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2011 04:51 AM, Suresh Siddha wrote:
> Updated patchset for cleaning up apic probe sequence by using apicdriver
> section.
> 
> Changes from V1:
>  * split up the patch into four small patches
>  * misc cleanups, specifying section alignment, removing duplicate messages
>    (from Cyrill and Yinghai's review comments)
>  * fixed a crash on smaller x64 systems
> 

I'll give them a spin tonight (if noone manage earlier). Thanks a lot Suresh!

-- 
            Cyrill
