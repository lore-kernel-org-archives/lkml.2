Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab1CALqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 06:46:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:20228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233Ab1CALqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 06:46:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,246,1297065600"; 
   d="scan'208";a="607691005"
Date: Tue, 1 Mar 2011 11:24:47 +0000
From: Alan Cox <alan@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Durgadoss R <durgadoss.r@intel.com>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] platform-driver-x86: intel_mid_thermal: fix
 unterminated platform_device_id table
Message-ID: <20110301112447.06315465@bob.linux.org.uk>
In-Reply-To: <1298732614.2762.6.camel@phoenix>
References: <1298732614.2762.6.camel@phoenix>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Feb 2011 23:03:34 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> The platform_device_id table is supposed to be zero-terminated.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Alan Cox <alan@linux.intel.com>
