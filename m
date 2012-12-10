Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2LJJSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:18:13 -0500
Received: from mx3.cyfra.ua ([62.80.160.182]:40401 "EHLO mx3.cyfra.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab2LJJSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:18:11 -0500
From: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Organization: Factor-SPE
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] drivers/uio/uio_pdrv_genirq.c: FIx memory & concurrency issues
Date: Mon, 10 Dec 2012 11:18:08 +0200
User-Agent: KMail/1.9.10
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Cong Ding <dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201212101118.08463.vitas@nppfactor.kiev.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series consists of two patches fixing different issues but in the 
same file, so the second patch depends on the first:
 1. Fix memory freeing issues
 2. Fix concurrency issue on SMP systems.
