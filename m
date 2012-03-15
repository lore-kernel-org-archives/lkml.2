Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964991Ab2COOdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:33:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:38118 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760869Ab2COOdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:33:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119324781"
Date: Thu, 15 Mar 2012 14:47:10 +0000
From: Alan Cox <alan@linux.intel.com>
To: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] gma500: Fix mmap frambuffer
Message-ID: <20120315144710.3d6ce9c5@bob.linux.org.uk>
In-Reply-To: <20120315212816.475b0b18.yuasa@linux-mips.org>
References: <20120315212816.475b0b18.yuasa@linux-mips.org>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012 21:28:16 +0900
Yoichi Yuasa <yuasa@linux-mips.org> wrote:

> 
> It cannot map correctly if page fault begins from a intermediate
> address.

Thanks, that explains one very strange bug I've been seeing !
