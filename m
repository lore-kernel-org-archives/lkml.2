Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448Ab2JKVth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 17:49:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39059 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759414Ab2JKVtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 17:49:36 -0400
Date: Thu, 11 Oct 2012 14:49:29 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/7]: PVH: PV guest with extensions
Message-ID: <20121011144929.06e71a9e@mantra.us.oracle.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Ok, I've made all the changes from prev RFC patch submissions. Tested
all the combinations. The patches are organized slightly differently
from prev version because of the nature of changes after last review. I
am building xen patch just for the corresponding header file changes.
Following that I'll refresh xen tree, debug, test, and send patches.

For linux kernel mailing list introduction, PVH is a PV guest that can
run in an HVM container, uses native pagetables, uses callback vector,
native IDT, and native syscalls.

They were built on top of 89d0307af2b9957d59bfb2a86aaa57464ff921de
commit.

thanks,
Mukesh
