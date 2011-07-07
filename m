Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab1GGJ7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 05:59:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:32813 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab1GGJ7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 05:59:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,492,1304319600"; 
   d="scan'208";a="22566254"
Date: Thu, 7 Jul 2011 11:00:15 +0100
From: Alan Cox <alan@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH 1/2] platform-drivers-x86: intel_rar_register: convert
 to DEFINE_PCI_DEVICE_TABLE
Message-ID: <20110707110015.083a17ed@bob.linux.org.uk>
In-Reply-To: <1310005275.2481.3.camel@phoenix>
References: <1310005275.2481.3.camel@phoenix>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jul 2011 10:21:15 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> And also remove unused variable 'my_id_table'.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied to mid tree looks fine to me

Signed-off-by: Alan Cox <alan@linux.intel.com>
