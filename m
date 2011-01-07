Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab1AGFoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 00:44:30 -0500
Received: from webbox4.loswebos.de ([213.187.93.205]:60270 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab1AGFo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 00:44:29 -0500
Date: Fri, 7 Jan 2011 06:44:17 +0100
From: Marc Koschewski <marc@osknowledge.org>
To: Linux-LKLM <linux-kernel@vger.kernel.org>
Subject: [REGRESSION g01539ba] Hibernate broken on T510i
Message-ID: <20110107054417.GA13752@marc.osknowledge.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E  38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.osknowledge.org/~marc/pubkey.asc
X-Operating-System: Linux marc 2.6.37-BFS-dezzy
User-Agent: Mutt/1.5.21hg (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

the latest git pull does not resume anymore. After hibernate if one is trying to
resume the box just resets itself and boots just fine as if never been hibernated.
dmesg says nothing weird prior to hibernate or on its way down...

I have this configured in grub: acpi_sleep=s3_bios,s3_mode,s4_nohwsig

Please ask in case you need any more info.

Regards,
	Marc

-- 
Marc Koschewski
