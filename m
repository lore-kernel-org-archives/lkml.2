Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab1CRVHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:07:37 -0400
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:42368 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932131Ab1CRVHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:07:31 -0400
Message-ID: <4D83C98F.5060309@blueyonder.co.uk>
Date: Fri, 18 Mar 2011 21:07:27 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7 ThunderBrowse/3.3.5
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pstore build error
References: <4D832BD0.4030809@blueyonder.co.uk> <20110318183339.GV23536@sequoia.sous-sol.org>
In-Reply-To: <20110318183339.GV23536@sequoia.sous-sol.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/03/11 18:33, Chris Wright wrote:
> * Sid Boyce (sboyce@blueyonder.co.uk) wrote:
>>    CC      fs/pstore/inode.o
>> fs/pstore/inode.c:253:2: error: unknown field ‘get_sb’ specified in
>> initializer
>
> https://lkml.org/lkml/2011/3/17/447
>
Thanks for the fix, now builds fine.
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support 
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

