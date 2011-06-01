Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab1FAAtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 20:49:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32522 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab1FAAtq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 20:49:46 -0400
MIME-Version: 1.0
Message-ID: <80f7ab04-7ae6-48cb-b254-e99343147bf0@default>
Date: Tue, 31 May 2011 17:49:21 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Wilk <konrad.wilk@oracle.com>
Subject: next phase of tmem into linux-next
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DE58CA4.00CC:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen --

Please re-include the following tree into linux-next.  The
commit series is for frontswap, the complement of cleancache
handling swap pages, which is the next phase in tmem.  It also
includes the shim code to Xen tmem for frontswap.  It applies
cleanly on linux-3.0-rc1, but if there are any problems or
you have any questions, please let me know!

git://git.kernel.org/pub/scm/linux/kernel/git/djm/tmem.git#linux-next

Thanks,
Dan
