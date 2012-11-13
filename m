Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab2KMPtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:49:24 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22812 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab2KMPqD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:46:03 -0500
MIME-Version: 1.0
Message-ID: <05faaa76-24af-42a5-9619-a627e3411f1a@default>
Date: Tue, 13 Nov 2012 07:45:39 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, andi@firstfloor.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, hannes@cmpxchg.org,
        yinghan@google.com, dan.magenheimer@oracle.com, konrad.wilk@oracle.com
Subject: RE: [PATCH 1/1] mm: Export a function to get vm committed memory
References: <<1352818957-9229-1-git-send-email-kys@microsoft.com>>
In-Reply-To: <<1352818957-9229-1-git-send-email-kys@microsoft.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Tuesday, November 13, 2012 8:03 AM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; andi@firstfloor.org; akpm@linux-foundation.org; linux-mm@kvack.org;
> kamezawa.hiroyuki@gmail.com; mhocko@suse.cz; hannes@cmpxchg.org; yinghan@google.com;
> dan.magenheimer@oracle.com; konrad.wilk@oracle.com
> Cc: K. Y. Srinivasan
> Subject: [PATCH 1/1] mm: Export a function to get vm committed memory
> 
> It will be useful to be able to access global memory commitment from device
> drivers. On the Hyper-V platform, the host has a policy engine to balance
> the available physical memory amongst all competing virtual machines
> hosted on a given node. This policy engine is driven by a number of metrics
> including the memory commitment reported by the guests. The balloon driver
> for Linux on Hyper-V will use this function to retrieve guest memory commitment.
> This function is also used in Xen self ballooning code.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

The patch to the Xen selfballoon driver is unnecessary, but is
one step in the direction of module support for this driver so
I am fine whether the patch is included here or not.

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
