Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab1IMN07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 09:26:59 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:49256 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab1IMN05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 09:26:57 -0400
Message-Id: <20110913132635.063397500@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 13 Sep 2011 15:26:35 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com, akpm@linux-foundation.org
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch v2 0/2] kdump: Allow removal of page tables for crashkernel memory
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek, Andrew, Martin

Here the updated patch series for the removal of page tables for the
crashkernel memory:

[1] kdump: Add infrastructure for unmapping crashkernel memory
[2] s390: Add architecture code for unmapping crashkernel memory

The patches apply on top of the last kdump patch series that I sent.

I would suggest that Martin sends the patches together with the other s390
kdump patches in the next merge window.

Andrew is that ok for you?

Michael
