Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab1EMRqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 13:46:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:23795 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1EMRqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 13:46:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,365,1301900400"; 
   d="scan'208";a="642392905"
Date: Fri, 13 May 2011 19:46:07 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>, Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: Fix off-by-one value range checking for
 tps65910_i2c_write
Message-ID: <20110513174606.GV8970@sortiz-mobl>
References: <1305278037.2713.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305278037.2713.1.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Fri, May 13, 2011 at 05:13:57PM +0800, Axel Lin wrote:
> If bytes == (TPS65910_MAX_REGISTER + 1), we have a buffer overflow when
> doing memcpy(&msg[1], src, bytes).
This code is going through Liam's tree, I'm adding him to this thread.
Liam, please add my Acked-by to this patch, if you think it's needed.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
