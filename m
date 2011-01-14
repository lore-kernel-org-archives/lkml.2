Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab1ANJvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:51:43 -0500
Received: from 26.mail-out.ovh.net ([91.121.27.225]:58255 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751462Ab1ANJvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:51:38 -0500
Message-ID: <4D301CA5.503@example.com>
Date: Fri, 14 Jan 2011 10:51:33 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: error in 2.6.37-git10
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 2064618954578227480
X-Ovh-Remote: 83.24.79.226 (dmx226.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Build failed here:

   CC [M]  fs/ecryptfs/main.o
fs/ecryptfs/main.c:144: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or 
‘__attribute__’ before ‘*’ token
fs/ecryptfs/main.c: In function ‘ecryptfs_interpose’:
fs/ecryptfs/main.c:204: error: implicit declaration of function 
‘ecryptfs_get_inode’
fs/ecryptfs/main.c:204: warning: initialization makes pointer from 
integer without a cast
fs/ecryptfs/main.c:206: error: expected ‘)’ before ‘return’
fs/ecryptfs/main.c:212: error: expected expression before ‘}’ token
fs/ecryptfs/main.c: In function ‘ecryptfs_mount’:
fs/ecryptfs/main.c:569: warning: assignment makes pointer from integer 
without a cast

Regards,

Piotr Hosowicz

-- 
Z cyklu "Uroki demokracji", czyli pytania i odpowiedzi w teledurniejach:
- Gdzie odbywały się lądowania Aliantów (D-Day)?
- Pearl Harbour?
NP: Patrick O'Hearn - Beautiful World
NB: 2.6.37-20110113-1411-pztidm+
