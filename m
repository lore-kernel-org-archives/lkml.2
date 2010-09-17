Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab0IQKOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 06:14:16 -0400
Received: from sr-smtp.usish.com ([210.5.144.203]:59001 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab0IQKOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 06:14:15 -0400
From: "Jack Wang" <jack_wang@usish.com>
To: "'James Bottomley'" <James.Bottomley@suse.de>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: "'lindar_liu'" <lindar_liu@usish.com>, "'roy'" <roy_wang@usish.com>
Subject: [BUG]Kernel 2.6.36rc4 crash when rmmod pm8001
Date: Fri, 17 Sep 2010 18:11:56 +0800
Message-ID: <3219F4D1734640238A632382C50F633E@usish.com.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: ActWUMIL1DdcoR14Rz2VnUPrl+UTow==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5931
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I update kernel to 2.6.36rc4 to test our driver, and found rmmod
pm8001 will cause system crash, then I rollback to 2.6.35.4 the driver
works as expected. Could someone any some hints for this? I'll give more
detailed messages if needed on Monday.

Thanks.
Jack

