Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab1DRSw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 14:52:28 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:4505 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380Ab1DRSwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 14:52:25 -0400
Message-ID: <4DAC8868.4090003@caviumnetworks.com>
Date: Mon, 18 Apr 2011 11:52:24 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] MIPS: Replace _PAGE_READ with _PAGE_NO_READ
References: <7aa38c32b7748a95e814e5bb0583f967@localhost>	<4DAC75C6.2060504@caviumnetworks.com> <BANLkTinbFNvez+G4LpmF7uwwJrH_J1NK8w@mail.gmail.com>
In-Reply-To: <BANLkTinbFNvez+G4LpmF7uwwJrH_J1NK8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Apr 2011 18:52:24.0662 (UTC) FILETIME=[C194A760:01CBFDF9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2011 11:24 AM, Kevin Cernekee wrote:
> On Mon, Apr 18, 2011 at 10:32 AM, David Daney<ddaney@caviumnetworks.com>  wrote:
>> How much testing have you done on non-RI/XI CPUs?
>
> On a non-RIXI CPU I was able to boot the system, run a basic GUI
> application, create R/W shared mappings to /dev/mem, insert/remove
> kernel modules, run a broken program that dumps core, etc.
>
> I guess it would be a good idea to make sure swap still works.  Didn't
> try that yet.
>
> Can you think of anything else that might exercise the bits that were
> touched by the patch?  Were there any tests you ran during the
> development of RIXI support which uncovered subtle issues?
>

We run the LTP, I think it tests these things.  We also have a small 
test case that tests for both the no-read and no-execute parts, but that 
would be expected to fail on platforms that don't have RI/XI bits.

David Daney
