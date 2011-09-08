Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab1IHN1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 09:27:05 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:41472 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778Ab1IHN1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 09:27:02 -0400
Message-Id: <20110908132609.177038405@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Thu, 08 Sep 2011 15:26:09 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [RFC][patch 0/2] kdump: Allow removal of page tables for crashkernel memory
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

I am back from vacation. We had one topic left that we didn't finish last time:
The removal of page tables for the crashkernel memory to protect the
loaded kdump kernel.

This patch series implements a new proposal for that:
[1] kdump: Add infrastructure for unmapping crashkernel memory
[2] s390: Add architecture code for unmapping crashkernel memory

The patches apply on the last kdump patch series that I sent.

Michael
