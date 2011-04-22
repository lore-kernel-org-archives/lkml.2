Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab1DVOhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 10:37:48 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:36481 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741Ab1DVOhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 10:37:47 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIKRsU1XQD0k/2dsb2JhbAClXXjEHoV2BJI0iWA
Message-ID: <4DB191C8.10501@computer.org>
Date: Fri, 22 Apr 2011 16:33:44 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: linux-kernel@vger.kernel.org, x86 <x86@kernel.org>
Subject: Re: [RFT] Please test rdtsc on various x86-64 hardware (app included)
References: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com>
In-Reply-To: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/04/11 21:32, Andrew Lutomirski wrote:
> Hi all-
>
> I'd appreciate some help testing rdtsc's ordering wrt memory on
> various hardware.

$ ./evil-clock-test
CPU vendor   : GenuineIntel
CPU model    : Intel(R) Core(TM) i3 CPU         540  @ 3.07GHz
CPU stepping : 2
TSC flags    : tsc rdtscp constant_tsc nonstop_tsc
Using lfence_rdtsc because you have an Intel CPU
Will test the "lfence;rdtsc" clock.
Now test passed  : margin 96 with 64336568 samples
Load3 test passed: margin 72 with 7731224 samples
Load test passed : margin 88 with 13575597 samples
Store test failed as expected: worst error 892 with 9605781 samples

Jan
