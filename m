Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab1IUTS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 15:18:56 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47029 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1IUTSx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 15:18:53 -0400
MIME-Version: 1.0
Message-ID: <b6034dd3-1750-49b5-b466-c125c9704db2@default>
Date: Wed, 21 Sep 2011 12:18:19 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Wilk <konrad.wilk@oracle.com>, akpm@linux-foundation.org
Subject: linux-next: tmem: temporary home for tmem.git tree (for frontswap,
 which is the final core kernel patchset for tmem)
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4E7A3894.00DD:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen --

There's a few tweaks in the tmem/frontswap patchset (for which
the current version was last pulled into linux-next from kernel.org).
Changes are mostly cosmetic and mostly in response to feedback from
Andrew Morton, with a bit of patchset restructuring suggested by
Konrad Wilk.  I've been hoping that kernel.org would come back up
but if it's not too much trouble to switch temporarily, please
switch tmem to:

git://oss.oracle.com/git/djm/tmem.git#tmem

I would appreciate having the exposure on the latest bits
before the 3.2 merge window.

Thanks!
Dan

Thanks... for the memory!
I really could use more / my throughput's on the floor
The balloon is flat / my swap disk's fat / I've OOM's in store
Overcommitted so much
(with apologies to Bob Hope)

