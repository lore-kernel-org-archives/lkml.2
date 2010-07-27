Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab0G0Ain (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 20:38:43 -0400
Received: from claw.goop.org ([74.207.240.146]:38308 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab0G0Ail (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 20:38:41 -0400
Message-ID: <4C4E2A90.3040902@goop.org>
Date: Mon, 26 Jul 2010 17:38:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 26 (xen)
References: <20100726154809.7f42c137.sfr@canb.auug.org.au> <20100726091651.f4ed28b8.randy.dunlap@oracle.com>
In-Reply-To: <20100726091651.f4ed28b8.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/26/2010 09:16 AM, Randy Dunlap wrote:
> On Mon, 26 Jul 2010 15:48:09 +1000 Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20100723:
>>
>> Undropped tree: xen
>>
>> The xen tree lost its build problems but gained a couple more for which I
>> reverted a commit and a subtreee.
>
> when CONFIG_SMP is not enabled:
>
> arch/x86/xen/enlighten.c:112: error: 'setup_max_cpus' undeclared (first use in this function)

Thanks, I've fixed it up.

     J

