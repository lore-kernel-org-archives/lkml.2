Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab1FVOGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:06:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34773 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1FVOGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:06:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=BsIYJU8BpFFiaq777RD58VC8rxfDQIGQBLKrNIC5Mnk2CYe6bjnOnl1JHhl2e0J6rU
         oB4LPH6I1TJGnsziigavsiNd067m/Un60obH2ZAo4ZVgIqw4ChyZ87O2Hba/yx0A4YyT
         eKaw7uQUkOK7Qur2g8gotYIswbBRp6+U2axIw=
Subject: [linux-next] Missing Makefile and Kconfig entry for
 drivers/mfd/tps65911-comparator.c?
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 22:06:26 +0800
Message-ID: <1308751586.22715.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just found that there is no Makefile and Kconfig entry for
drivers/mfd/tps65911-comparator.c, how to build this driver?

Regards,
Axel


