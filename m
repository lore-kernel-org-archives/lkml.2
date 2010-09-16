Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab0IPV4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 17:56:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33372 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab0IPV4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 17:56:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=TkvoaTGyRang6b2CuTKbQyF7WbJlCEkuYKBT2i/ttAq+0cWj7nfrEkAstKz1zvbic+
         AjOwMHI0dyIdF975TkvLe7PWcUGB8kufasw5k1Qp4B3FnxzpKh5FzAH35ulhQpD97b6a
         HajsKepRh7aQDet93lLL4BRCHlmPYIaFfZY/w=
From: Pedro Francisco <pedrogfrancisco@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: ahci rmmodable and shouldn't
Date: Thu, 16 Sep 2010 22:56:04 +0100
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009162256.04765.pedrogfrancisco@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I reported this here for 2.6.35.4 -- http://lkml.org/lkml/2010/9/7/321 -- but 
still happens on latest -git.

`rmmod ahci' works even if the module is being used (`lsmod' thinks it's not 
being used but rmmoding ahci triggers filesystem erros and I've to force a 
reboot).

I've been told it's the same as plugging a cable. IMO that's what 
/sys/stuff/eject_or_similar is to, not `rmmod ahci'.

I *assume* it was caused by the split between libahci & ahci, since in 2.6.32 
`rmmod ahci' is impossible because it's marked as being in use. Didn't try 
`rmmod -f ahci' but that's not the point.

I'm posting again about this because it doesn't make sense to me the actual 
behaviour.

TIA,
-- 
Pedro
