Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab1HUCb2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 22:31:28 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48900 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1HUCb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 22:31:27 -0400
Message-ID: <4E506DEA.1070601@gmail.com>
Date: Sat, 20 Aug 2011 19:31:06 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: using mce_inject I get: RIP 10:<ffffffffa012c909> {ttm_bo_unref+0xf/0x45
 [ttm]}
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

not sure if I am running mce_test correctly, but during its routine of 
testing things I do get a pause with everything, then the below shows up 
in dmesg..:

http://fpaste.org/kMRd/


[ 1810.670434] Triggering MCE exception on CPU 1
[ 1810.670462] [Hardware Error]: CPU 1: Machine Check Exception: 6 Bank 
4: b300000000000000
[ 1810.670467] [Hardware Error]: RIP 73:<0000000012343434>
[ 1810.670470] [Hardware Error]: TSC 38d1002c216
[ 1810.670474] [Hardware Error]: PROCESSOR 0:6f6 TIME 1313892803 SOCKET 
0 APIC 1
[ 1810.670477] [Hardware Error]: Run the above through 'mcelog --ascii'
[ 1810.670481] [Hardware Error]: Machine check: Processor context corrupt
[ 1810.670483] [Hardware Error]: Fake kernel panic: Fatal Machine check
[ 1810.670495] MCE exception done on CPU 1
[ 1819.064721] Triggering MCE exception on CPU 1

seems light of a pause, then everything resumes properly(music, etc..).
Is this something that needs attention, or are these tests as extreme as 
can be, and should simply be ignored?
(Note: if there is a mce list somewhere let me know so I direct this to 
the proper people)

Justin P. Mattock
