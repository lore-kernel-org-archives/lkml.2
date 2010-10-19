Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933731Ab0JSJ00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:26:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:23761 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393Ab0JSJ0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:26:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,349,1283756400"; 
   d="scan'208";a="848591262"
Date: Tue, 19 Oct 2010 11:26:16 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: David Jander <david@protonic.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mfd/mc13xxx: add support for mc13892
Message-ID: <20101019092615.GD2736@sortiz-mobl>
References: <20100929162315.GG29811@pengutronix.de>
 <1285777427-2887-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <20101007184501.GX29673@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101007184501.GX29673@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Thu, Oct 07, 2010 at 08:45:01PM +0200, Uwe Kleine-König wrote:
> > +#define DEBUG
> > +#define VERBOSE_DEBUG
> David Jander gave me a hint via private mail that I forgot to remove
> these two #defines.
> Would you care to remove these before Linus pulls?  Should I send a
> patch or do you do it by hand?
That's fixed now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
