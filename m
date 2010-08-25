Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab0HYIPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 04:15:34 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:35492 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab0HYIPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 04:15:32 -0400
Date: Wed, 25 Aug 2010 09:15:30 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Ivan Bulatovic <combuster@gmx.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] drm/i915/tv: After disabling the pipe, use
	wait_for_vblank_off()
Message-ID: <20100825081530.GB30504@sucs.org>
References: <1282647815.2221.15.camel@localhost.localdomain> <1282662712-20493-1-git-send-email-chris@chris-wilson.co.uk> <1282684130.2199.25.camel@localhost.localdomain> <89k83a$9drtkt@azsmga001.ch.intel.com> <1282691196.2120.30.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282691196.2120.30.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 01:06:36AM +0200, Ivan Bulatovic wrote:
> 
> Spurious TV detection is still here and + I have a new problem with
> resolution in init3 when KMS fires up, it occupies only 1/3rd of the
> screen when booting.

Does the patch in http://lkml.org/lkml/2010/8/24/280 change anything for
you? If so I'm guessing we are seeing the same issue...

-- 
Sitsofe | http://sucs.org/~sits/
