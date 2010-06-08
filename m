Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab0FHNNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 09:13:33 -0400
Received: from n2-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.154]:29029 "HELO
	n2-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754288Ab0FHNNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 09:13:31 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 78935.55802.bm@omp121.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=tGy6R0Bi3+JOFeRbqZXCHjR5RvwgAwm1sOYNethM6ulYuTGUeO8trdDGUdY7SKVwYgiIfnjw5Ze0cOFQdl6BD8yn1Shl238CTTRVSfwRpyhUkYBY8xuHvSdP4HvOREayJ+jW6CRbYyfzr4qjxMo6oosbyw3xYZETGlB4HHLDgDI=;
Message-ID: <996015.66352.qm@web180311.mail.gq1.yahoo.com>
X-YMail-OSG: SlEQ3zMVM1nS0REV0SigaYFOUplkx1fdgH83db4QfL5o8l.
 KlJcNBGVXMixC_XNCMHDxA8PT8b2E_sWhS8phMWaAafAYT2gDau0Tw3.rqJ6
 SZ7uUJHJxWDHaou.4Csde39G9N2O5qKkjRjJMW_PTMeDJHQgUfg58HPI0x4C
 H0Q_lapxnWeEfGrnqZBqZN9GP.2vCZVB6nj5MJmbTKjeKcwFCcvIkZD_MHGD
 bA49S6HKkVMgPZPF7ThmLAbILuNyP_u1XS_5A1cB9x4UB1wynThx930k2de6
 s06JRhlx0Xv0EQg_Qy9.lwPFsOvY.ViOajaRREHwawMnJ24z19bsdyg--
X-Mailer: YahooMailClassic/11.0.8 YahooMailWebService/0.8.103.269680
Date: Tue, 8 Jun 2010 06:13:30 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv4 08/13] USB: gadget: g_serial: INF file updated
To: linux-usb@vger.kernel.org, Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Xiaofan Chen <xiaofanc@gmail.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <61c7dcd3597ed56ec1caa5bcb66bf9bc1b09fb66.1275906835.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +; Copyright (c) 2000 Microsoft Corporation

Same comment as with the INF file for g_ether:

If you're giving Microsoft credit for this,
you should make sure we have the right to
redistribute the changes ...

To the extent that your patches reduce our
ability to redistribute these INF files and
thus use these drivers with MS-Windows ... NAK.

It's my understanding that pulling fragments
from INF files comes under "fair use" and
thus copyright does not need to be assigned.
Microsoft publishes these things with the
expectation they'll be copied/pasted all over...

