Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab2JRAZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 20:25:19 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42604 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab2JRAZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 20:25:18 -0400
Date: Wed, 17 Oct 2012 17:25:11 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH V3 0/6]: PVH: PV guest with extensions
Message-ID: <20121017172511.40e0bb28@mantra.us.oracle.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Ok, I've made the changes from prev V2 patch submission comments. Tested
all the combinations. I am building xen patch just for the
corresponding header file changes. Following that I'll refresh xen
tree, debug, test, and send patches.

For linux kernel mailing list introduction, PVH is a PV guest that can
run in an HVM container, uses native pagetables, uses callback vector,
native IDT, and native syscalls.

They were built on top of 89d0307af2b9957d59bfb2a86aaa57464ff921de
commit.

thanks,
Mukesh
