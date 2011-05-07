Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1EGNpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 09:45:17 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:56132 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab1EGNpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 09:45:12 -0400
Message-ID: <4DC54CE5.6050307@xs4all.nl>
Date: Sat, 07 May 2011 15:45:09 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: AMD C1E issue?   2.6.38.4
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Saw these in my messages after enabling C1E on my new Jetway Mini-ITX board:

# microcode_ctl -u
microcode_ctl: writing microcode (length: 430080)
microcode_ctl: error writing to '/dev/cpu/microcode' errno=22 (Invalid
argument)
microcode_ctl: there may be messages from the driver in your system log.

microcode: AMD microcode update via /dev/cpu/microcode not supported
microcode: AMD microcode update via /dev/cpu/microcode not supported

This is on kernel.org 2.6.38.4 on AMD Athlon II X2 235e on JNC84E-LF
board, Fedora 14 for most of the rest of the stuff.

Anybody can tell why the update cannot work?
The previous board (JNC81) did not show these but also did not have C1E
in BIOS as far as I recall.


Please explain.

Kind regards,
Udo
