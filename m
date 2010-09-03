Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab0ICQjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 12:39:52 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56695 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab0ICQjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 12:39:51 -0400
From: Borislav Petkov <bp@amd64.org>
To: Dave Airlie <airlied@redhat.com>, <hpa@zytor.com>, <mingo@elte.hu>,
        <tglx@linutronix.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: <akpm@linux-foundation.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/3] x86, AMD: GART optimization
Date: Fri,  3 Sep 2010 18:39:38 +0200
Message-Id: <1283531981-7495-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi,

this is a mini-set that disables the generation of GART TLB walk probes
and should improve GART TLB walk speed when the GART is being used as an
IOMMU. We've been hammering on the changes with a bunch of iotests from
the autotest suite and using "iommu=force" for a while now and have seen
no regressions so far.

Please apply,

Thanks.
