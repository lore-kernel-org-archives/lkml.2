Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab1EMS5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:57:32 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:1189 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab1EMS5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:57:31 -0400
Message-ID: <4DCD7F1A.3040904@caviumnetworks.com>
Date: Fri, 13 May 2011 11:57:30 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "Jayachandran C." <jayachandranc@netlogicmicro.com>
CC: Kevin Cernekee <cernekee@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] MIPS: Replace _PAGE_READ with _PAGE_NO_READ
References: <7aa38c32b7748a95e814e5bb0583f967@localhost> <20110513150707.GA26389@linux-mips.org> <BANLkTikcyEzjOWt9pWToE=89dySSEYbw_g@mail.gmail.com> <20110513155605.GA30674@linux-mips.org> <BANLkTinnALQV6dXkJ0AjaQ1=bTawYMMkuQ@mail.gmail.com> <20110513173633.GA14607@jayachandranc.netlogicmicro.com> <BANLkTim+z7TSCvNA2duA6LsUzNsiu9OQaQ@mail.gmail.com> <20110513184532.GC14607@jayachandranc.netlogicmicro.com>
In-Reply-To: <20110513184532.GC14607@jayachandranc.netlogicmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 May 2011 18:57:30.0519 (UTC) FILETIME=[9C367A70:01CC119F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2011 11:45 AM, Jayachandran C. wrote:
> On Fri, May 13, 2011 at 10:51:44AM -0700, Kevin Cernekee wrote:
>> On Fri, May 13, 2011 at 10:36 AM, Jayachandran C.
>> <jayachandranc@netlogicmicro.com>  wrote:
>>> For 32-bit the config is nlm_xlr_defconfig in the source tree. Let me know if
>>> you need any further info.
>>
>> Would you be able to dump out the TLB handlers in this configuration,
>> per David's suggestion?
>
> The current linux-mips queue works for me, and I don't have the old source
> or binaries with me anymore. You surely should be able build with
> nlm_xlr_defconfig and see if the rixi is enabled in the build, if you want
> any config register dump on the CPU, please let me know.

The problem is that we don't have your hardware to test anything on.

Kevin's patches are a good cleanup, but we cannot use them if they break 
things.  So the ideal situation would be for people maintaining the 
failing ports to help figure out where they fail.

David Daney
