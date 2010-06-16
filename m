Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041Ab0FPOtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 10:49:13 -0400
Received: from fallback2.mail.ru ([94.100.176.87]:40090 "EHLO
	fallback2.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758923Ab0FPOtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 10:49:12 -0400
X-Greylist: delayed 6159 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jun 2010 10:49:12 EDT
From: =?koi8-r?Q?=F0=C1=CE=D4=C5=CC=C5=C5=D7_=F0=C1=D7=C5=CC?= 
	<pp_84@mail.ru>
To: andi@firstfloor.org, linux-mm@kvak.org, linux-kernel@vger.kernel.org
Subject: [patch] percpu in linux-2.6.35-rc3
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: unknown via proxy [213.247.249.139]
Date: Wed, 16 Jun 2010 15:44:43 +0400
Reply-To: =?koi8-r?Q?=F0=C1=CE=D4=C5=CC=C5=C5=D7_=F0=C1=D7=C5=CC?= 
	  <pp_84@mail.ru>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1OOr2x-0008Mw-00.pp_84-mail-ru@f178.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello! My name is Pavel V. Panteleev. 

While working with percpu on linux-2.6.35-rc3 I have found trivial bugs in pcpu_build_alloc_info() function:
- we should memset group_cnt to 0 by size of group_cnt, not size of group_map;
- we can delete useless variable group_cnt_max.

Best regards,
Pavel V. Panteleev
