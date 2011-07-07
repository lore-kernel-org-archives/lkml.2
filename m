Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab1GGCke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 22:40:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:57633 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab1GGCkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 22:40:33 -0400
Subject: Re: [PATCH] pch_dma: Fix channel locking
From: Vinod Koul <vkoul@infradead.org>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Alexander Stein <alexander.stein@systec-electronic.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        "Wang, Qi" <qi.wang@intel.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>
In-Reply-To: <4E0AFDCA.3050908@dsn.okisemi.com>
References: <1308755133-8605-1-git-send-email-alexander.stein@systec-electronic.com>
	 <201106271622.52763.alexander.stein@systec-electronic.com>
	 <4E09AE3A.8050306@dsn.okisemi.com>
	 <201106290828.06508.alexander.stein@systec-electronic.com>
	 <4E0AFDCA.3050908@dsn.okisemi.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Thu, 07 Jul 2011 07:08:51 +0530
Message-ID: <1310002731.20150.5.camel@psiaudioba-mobl1>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 19:26 +0900, Tomoya MORINAGA wrote:
> (2011/06/29 15:28), Alexander Stein wrote:
> > Are you sure you applied the patch? There shouldn't be a _raw_spin_lock_bh
> > here.
> > 
> 
> You are right.
> I tested again, as a result,
> I could confirm that after using your patch,
> kernel error message doesn't logged at all.
> It seems my patching yesterday was failed or operation mistake.
> Sorry for the in inconvenience.
> 
Care to send tested your by, before I apply this patch?

-- 
~Vinod Koul
Intel Corp.

