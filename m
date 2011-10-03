Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab1JCOsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 10:48:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46841 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab1JCOsl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 10:48:41 -0400
From: "Premi, Sanjeev" <premi@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 3 Oct 2011 20:18:36 +0530
Subject: RE: [PATCH] kconfig: fix warnings due to unused return values
Thread-Topic: [PATCH] kconfig: fix warnings due to unused return values
Thread-Index: Acx5G+T4By9qa1y/Qf+0VgU+OtPs4QIv3wEQ
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59302578FA0F6@dbde02.ent.ti.com>
References: <1316691396-25447-1-git-send-email-premi@ti.com>
In-Reply-To: <1316691396-25447-1-git-send-email-premi@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Premi, Sanjeev 
> Sent: Thursday, September 22, 2011 5:07 PM
> To: linux-kernel@vger.kernel.org
> Cc: Premi, Sanjeev
> Subject: [PATCH] kconfig: fix warnings due to unused return values
> 
> The return value of wattrset() is being ignored in the
> code and newer compilers complain about this e.g.
> 
> HOSTCC  scripts/kconfig/lxdialog/checklist.o
> scripts/kconfig/lxdialog/checklist.c: In function print_item:
> scripts/kconfig/lxdialog/checklist.c:40: warning: value 
> computed is not used
> scripts/kconfig/lxdialog/checklist.c:46: warning: value 
> computed is not used
> 
> Let the compiler know that ignore is intentional.
> 
> Signed-off-by: Sanjeev Premi <premi@ti.com>
> ---

Just wanted to ping on the status...

~sanjeev

[snip]...[snip]