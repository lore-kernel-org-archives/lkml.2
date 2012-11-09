Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab2KINsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 08:48:19 -0500
Received: from mail.agmk.net ([91.192.224.71]:60341 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab2KINsR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:48:17 -0500
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, torvalds@linux-foundation.org, arekm@pld-linux.org,
        baggins@pld-linux.org
Subject: [3.6.6] panic on reboot / khungtaskd blocked? (WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule)
Date: Fri, 09 Nov 2012 14:48:10 +0100
Message-ID: <56378024.A3Kec8xZj0@pawels>
User-Agent: KMail/4.9.1 (Linux/3.6.6; KDE/4.9.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

during playing with new ups i've caught an nice oops on reboot:

http://imgbin.org/index.php?page=image&id=10253

probably the upstream is also affected.

BR,
Paweł.

