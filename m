Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1GDVF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 17:05:57 -0400
Received: from smtprelay0057.b.hostedemail.com ([64.98.42.57]:57768 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751905Ab1GDVFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 17:05:55 -0400
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 1110
Date: Mon, 4 Jul 2011 20:58:21 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1275302769.22157.1309813101668.JavaMail.mail@webmail11>
Subject: About sched_mc_power_savings
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.146.237.52]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I feel a little bit stupid and surprised but supposedly I should have sched_mc_power_savings files in my /sys since I have CONFIG_SCHED_MC defined in my .config and I have a four cores CPU (to be exact Intel Core i5 2500).

Alas, under Linux kernel 3.0-rc5 I don't have the aforementioned files.

Is something wrong going on here?



Best wishes,

Artem
