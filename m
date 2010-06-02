Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab0FBUWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:22:47 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:33868 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932641Ab0FBUWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:22:45 -0400
Date: Wed, 2 Jun 2010 16:22:15 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: David John <davidjon@xenontk.org>
Cc: cworth@cworth.org, Dave Airlie <airlied@linux.ie>,
       Eric Anholt <eric@anholt.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.35-rc1 Regression] i915: Commit cfecde causes VGA to stay
 off
Message-ID: <20100602202215.GA2383@elliptictech.com>
Mail-Followup-To: David John <davidjon@xenontk.org>, cworth@cworth.org,
	Dave Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4C065423.3000202@xenontk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C065423.3000202@xenontk.org>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:22 Wed 02 Jun     , David John wrote:
> Commit cfecde 'drm/i915: Don't enable pipe/plane/VCO early (wait for
> DPMS on)' causes the external VGA connector to stay off on boot. The
> display powers up when X is started. I'm guessing an explicit DPMS ON
> is not done on boot.

It gets worse: my primary (and only) display is VGA, and my monitor
reports that it has been configured to an invalid mode.  The result is
no usable display.

> Reverting this commit fixes the issue.

Likewise.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
