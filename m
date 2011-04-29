Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788Ab1D2QK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 12:10:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39472 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759754Ab1D2QKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 12:10:22 -0400
Message-ID: <4DBAE2B1.1020207@zytor.com>
Date: Fri, 29 Apr 2011 09:09:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110422 Fedora/3.1.9-7.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, castet.matthieu@free.fr,
        sfr@canb.auug.org.au, tglx@linutronix.de, rjw@sisk.pl,
        hpa@linux.intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/trampoline] x86, reboot: Move the real-mode reboot code
 to an assembly file
References: <4D5DFBE4.7090104@intel.com>	<tip-3d35ac346e981162eeba391e496faceed4753e7b@git.kernel.org> <BANLkTikf9zUSwJKBbZ+A_6Yu5aeXOtggBQ@mail.gmail.com>
In-Reply-To: <BANLkTikf9zUSwJKBbZ+A_6Yu5aeXOtggBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2011 08:16 AM, Alexey Zaytsev wrote:
> On Fri, Feb 18, 2011 at 08:20, tip-bot for H. Peter Anvin
> <hpa@linux.intel.com> wrote:
>> Commit-ID:  3d35ac346e981162eeba391e496faceed4753e7b
>> Gitweb:     http://git.kernel.org/tip/3d35ac346e981162eeba391e496faceed4753e7b
>> Author:     H. Peter Anvin <hpa@linux.intel.com>
>> AuthorDate: Mon, 14 Feb 2011 18:36:03 -0800
>> Committer:  H. Peter Anvin <hpa@linux.intel.com>
>> CommitDate: Thu, 17 Feb 2011 21:05:34 -0800
>>
>> x86, reboot: Move the real-mode reboot code to an assembly file
>>
>> Move the real-mode reboot code out to an assembly file (reboot_32.S)
>> which is allocated using the common lowmem trampoline allocator.
>>
> 
> Hi. This one causes problems on at least a couple HP Compaq laptops:
> https://bugzilla.kernel.org/show_bug.cgi?id=33302
> 

Saw that... trying to figure out how to reproduce it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

