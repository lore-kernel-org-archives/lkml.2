Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab1ITOen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:34:43 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:51054 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1ITOej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:34:39 -0400
Message-Id: <20110920143400.776127689@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 20 Sep 2011 16:34:00 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: vgoyal@redhat.com, ebiederm@xmission.com, mahesh@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [patch 0/2] kdump: Initialize vmcoreinfo note at startup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

Another common code patch that we would like to have upstream is the vmcoreinfo
note initialization at Linux startup time. We need that for our traditional
stand-alone and hypervisor dump tools.

[1] kdump: Initialize vmcoreinfo note at startup
[2] s390: Export vmcoreinfo note

I already have discussed this with Vivek and he has acked the common code
patch [1].

Do you agree that Martin sends these patches together with the kdump page
table patches (see https://lkml.org/lkml/2011/9/15/55) in the next merge
window?

Michael
