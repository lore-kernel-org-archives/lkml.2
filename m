Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab1DRVuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 17:50:00 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:46572 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751875Ab1DRVt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 17:49:59 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: 2.6.39-rc3-gitX  compiling errors of olpc-dcon_xo_1 and
 i82975x-edac
To: tj@kernel.org, gregkh@suse.de, randy.dunlap@oracle.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Mon, 18 Apr 2011 17:49:55 -0400
Message-ID: <web-507861711@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=============================

   CC [M]  drivers/staging/olpc_dcon/olpc_dcon_xo_1.o
drivers/staging/olpc_dcon/olpc_dcon_xo_1.c: In function 
'dcon_wiggle_xo_1':
drivers/staging/olpc_dcon/olpc_dcon_xo_1.c:168: error: 
implicit declaration of function 'udelay'



   CC [M]  drivers/edac/i82975x_edac.o
drivers/edac/i82975x_edac.c: In function 
'i82975x_process_error_info':
drivers/edac/i82975x_edac.c:298: warning: integer constant 
is too large for 'unsigned long' type








---
Professional hosting for everyone - http://www.host.ru
