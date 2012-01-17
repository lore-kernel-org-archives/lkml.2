Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab2AQRNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:13:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:40494 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120Ab2AQRNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:13:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="99615522"
Subject: Re: [PATCH 4/15] drivers/dma/pl330.c: add missing iounmap
From: Vinod Koul <vinod.koul@intel.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Dan Williams <dan.j.williams@intel.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.02.1201171754480.1897@localhost6.localdomain6>
References: <1326362117-29371-4-git-send-email-Julia.Lawall@lip6.fr>
	 <1326819104.1540.166.camel@vkoul-udesk3>
	 <alpine.DEB.2.02.1201171754480.1897@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jan 2012 22:44:19 +0530
Message-ID: <1326820459.1540.171.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-17 at 17:55 +0100, Julia Lawall wrote:
> >> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> > Acked by Vinod Koul <vinod.koul@linux.intel.com>
> >
> > Which tree is this intended for?
> 
> It was generated from linux-next, although I'm not sure if that is
> the 
> intended sense of the question.
I meant, which tree is this intended to be merged thru?
slave-dma or any other. Since this is patch is series, typically a
series is applied thru a single tree. If that is not the case, then I am
happy to apply thru slave-dma :)

-- 
~Vinod

