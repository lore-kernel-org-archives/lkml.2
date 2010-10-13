Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab0JMKL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 06:11:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:7589 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab0JMKL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 06:11:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,324,1283756400"; 
   d="scan'208";a="666975258"
Date: Wed, 13 Oct 2010 10:20:17 +0100
From: Alan Cox <alan@linux.intel.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Harsha Priya <priya.harsha@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: intel_sst: use signed int for error codes
Message-ID: <20101013102017.7d60090c@linux.intel.com>
In-Reply-To: <1286731724-17996-1-git-send-email-segooon@gmail.com>
References: <1286731724-17996-1-git-send-email-segooon@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Oct 2010 21:28:43 +0400
Vasiliy Kulikov <segooon@gmail.com> wrote:

> As retval stores error code, it should be signed int.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Acked-by: Alan Cox <alan@linux.intel.com>
