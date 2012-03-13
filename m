Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2CMUhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 16:37:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63158 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab2CMUhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 16:37:31 -0400
Message-ID: <4F5FB008.5030402@pobox.com>
Date: Tue, 13 Mar 2012 16:37:28 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Brian Norris <computersforpeace@gmail.com>, linux-ide@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Lin Ming <ming.m.lin@intel.com>, Norbert Preining <preining@logic.at>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        "Rafael J . Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v2 0/3] ahci: fix boot/resume COMRESET failures
References: <1329849524-23758-1-git-send-email-computersforpeace@gmail.com> <20120312221209.GH23255@google.com>
In-Reply-To: <20120312221209.GH23255@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 06:12 PM, Tejun Heo wrote:
> On Tue, Feb 21, 2012 at 10:38:41AM -0800, Brian Norris wrote:
>> This series addresses regression problems with
>>
>>      commit 7faa33da9b7add01db9f1ad92c6a5d9145e940a7
>>      ahci: start engine only during soft/hard resets
>>
>> Because the fix provided by the above commit caused COMRESET failures and
>> 10 second boot-time/resume-time hangs for certain DVD drives, we need to
>> make the fix conditional to certain devices/platforms. Add a flag for this.
>>
>> Brian
>>
>> v2: change flag name to AHCI_HFLAG_DELAY_ENGINE, write more detailed
>>      comments
>>
>> v1: flag named AHCI_HFLAG_STRICT_SPEC
>>
>> Brian Norris (3):
>>    ahci: add AHCI_HFLAG_DELAY_ENGINE host flag
>>    ahci: move AHCI_HFLAGS() macro to ahci.h
>>    ahci_platform: add STRICT_AHCI platform type
>
> This looks good to me.  Jeff?

Yep.  Added Cc stable@kernel.org to the commit messages.

	Jeff




