Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab0IWNec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 09:34:32 -0400
Received: from fallback5.mail.ru ([94.100.176.59]:40522 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab0IWNec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 09:34:32 -0400
From: Alex Mach <alexvm12e@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: Question about interrupt processing on Sparc64
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: [213.182.162.106]
Date: Thu, 23 Sep 2010 17:31:08 +0400
Reply-To: Alex Mach <alexvm12e@mail.ru>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1OyltE-0002me-00.alexvm12e-mail-ru@f57.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

Why ttable.S and sun4v_ivec.S aren't linked to kernel in Makefile at /arch/sparc/kernel? As I understend these files are necessary for interrupt processing (sun4v_dev_mondo() and handle_irq() functions).

Thanks,
Alex.



