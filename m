Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab0FBWVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:21:12 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:34684 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962Ab0FBWVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:21:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:organization:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=Q1i83P2kmVtn8L43XGVw20T5qSZ78s3B62WELYgRM0HSMLlb/UKhL37Qs9m84D/nFd
         ujLzdLe726qNlcMjuNyz55fzAf0jfzxbAzX5CEAoeHpT30xmf3Ug42PGALasX9PVQ0qr
         5hnOsKgnR5qHmvlQPT7BqT3tcGOTVUlpkzN0M=
From: Grant Coady <gcoady.lk@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: How to stop kernel rebooting during startup?
Date: Thu, 03 Jun 2010 08:20:54 +1000
Organization: scattered
Message-ID: <kqld06dbv2ektmqfadr8l3dqtmm6hler2c@4ax.com>
X-Mailer: Forte Agent 6.00/32.1186
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Kernel has a problem mounting root, but it reboots before I can read 
the message.  Of course nothing gets logged so I cannot see exactly 
why the kernel wants to reboot.

Can I stop kernel doing an automatic reboot?  How?  

It's version 2.6.33.5, .4 has same behaviour.  Filesystem is Reiserfs, 
Intel ICH9R with Core2Duo, .config is on: 

  http://bugsplatter.id.au/kernel/boxen/pooh64/config-2.6.33.5a.gz

which worked fine on slackware64-13.0, has this behaviour on slack-
ware64-13.1.  Because I cannot read the screen before reboot, no idea 
where to look next, or what is actually happening.

Thanks,
Grant.
