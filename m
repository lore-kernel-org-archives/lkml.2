Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab1GKTWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:22:24 -0400
Received: from smtpo.poczta.interia.pl ([217.74.65.206]:48312 "EHLO
	smtpo.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab1GKTWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:22:23 -0400
Message-ID: <4E1B4D5C.7090301@interia.pl>
Date: Mon, 11 Jul 2011 20:22:04 +0100
From: =?UTF-8?b?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110628
	Thunderbird/5.0
MIME-Version: 1.0
To: Harald Welte <HaraldWelte@viatech.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: CPUFREQ: Mark e_powersaver driver as EXPERIMENTAL and DANGEROUS
X-Interia-Antivirus: OK
X-EMID: 9c77f958
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Sorry for late reply. I've been aware problem with "e_powersaver". 
Nobody ever e-mailed me :-)
So far I'm aware "e_powersaver" fully respects values given it by CPU. 
Only code added by VIA
seems to be faulty for me. As I understand ACPI P-States provide 
unstable 400MHz for system in question too.
If "e_powersaver" was based on outdated documentation I'm sorry. This 
driver was neccessary for systems with
C7 CPU's which didn't provide BIOS P-states. But it was in early and 
dark ages of first C7 CPU's.

Bye




----------------------------------------------------------------
Najwieksza baza samochodow nowych i uzywanych
Sprawdz >> http://linkint.pl/f29e3
