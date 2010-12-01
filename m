Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab0LAQKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 11:10:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40841 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab0LAQKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 11:10:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Jsm9cyofeR2MQFTVDXA/+YksOQ0Ig6IlbwXquOeH+891i1juA6HmqK5oXFkFrvoHqG
         gf2Tgb6Q9/Hp5NHiSlyPzGpYyFacIcZps/C9rkl6DdYbrr6JD08x7xGU+qh5RR43YcII
         F3wm+yirwAj1cnVitOU4nDx8PR3nNE8ifz6GU=
Subject: Subject: [RFC 0/3] VSMP support for msp71xx platforms
From: Anoop P A <anoop.pa@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, mcdonald.shane@gmail.com,
        "Kevin D. Kissell" <kevink@paralogos.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 21:43:11 +0530
Message-ID: <1291219991.31413.8.camel@paanoop1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5bfd3ba210e521df2b493862446b4535bcdb0cdf Mon Sep 17 00:00:00 2001
Message-Id: <cover.1291219118.git.anoop.pa@gmail.com>
From: Anoop P A <anoop.pa@gmail.com>
Date: Wed, 1 Dec 2010 21:28:38 +0530
Subject: [RFC 0/3] VSMP support for msp71xx platforms
Cc: anoop.pa@gmail.com

Following series patches add VSMP support for MSP71xx series of SoC's.


Anoop P A (3):
  VSMP support for msp71xx family of platforms.
  SMP support MSP CIC and PER cascaded interrupt subsystem.
  VSMP support for MSP71xx family.

 arch/mips/pmc-sierra/msp71xx/Makefile      |    3 +-
 arch/mips/pmc-sierra/msp71xx/msp_irq.c     |   49 +++++-
 arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c |  245
+++++++++++++++++++---------
 arch/mips/pmc-sierra/msp71xx/msp_irq_per.c |  175 ++++++++++++++++++++
 arch/mips/pmc-sierra/msp71xx/msp_setup.c   |    3 +
 arch/mips/pmc-sierra/msp71xx/msp_smp.c     |   75 +++++++++
 arch/mips/pmc-sierra/msp71xx/msp_time.c    |    2 +-
 7 files changed, 463 insertions(+), 89 deletions(-)
 create mode 100644 arch/mips/pmc-sierra/msp71xx/msp_irq_per.c
 create mode 100644 arch/mips/pmc-sierra/msp71xx/msp_smp.c



