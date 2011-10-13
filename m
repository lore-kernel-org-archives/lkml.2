Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab1JMHVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 03:21:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62503 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab1JMHU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 03:20:59 -0400
Message-ID: <1318490454.2202.4.camel@jan-VPCM11M1E>
Subject: Kernel-panic on battery
From: Jan Steinke <jan.steinke@googlemail.com>
To: linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 09:20:54 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0-
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hay LKML Guys,
I reported a kernel bug to the Ubuntu Team about a panic occurring
during battery state. I tested it with the latest upstream kernel.

The bug appears at around 85% of Battery on a Vaio VPCM11M1E Netbook.
have not checked with other machines.

link to the Ubuntu Bug:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/862221

Jan

