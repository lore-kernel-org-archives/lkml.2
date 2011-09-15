Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab1IOJGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 05:06:15 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:34767 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab1IOJFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 05:05:48 -0400
Message-Id: <20110915090440.063421605@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Thu, 15 Sep 2011 11:04:40 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com, akpm@linux-foundation.org
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch v3 0/2] kdump: Allow removal of page tables for crashkernel memory
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek, Andrew, Martin

Here the version 3 patch series for the removal of page tables for the
crashkernel memory:

[1] kdump: Add infrastructure for unmapping crashkernel memory
[2] s390: Add architecture code for unmapping crashkernel memory

Changes to version 2: Use resource_size()

The patches apply on top of the last kdump patch series that I sent.

I would suggest that Martin sends the patches together with the other s390
kdump patches in the next merge window.

Michael
