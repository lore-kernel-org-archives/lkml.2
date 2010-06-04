Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab0FDP1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 11:27:50 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:56293 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750998Ab0FDP1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 11:27:49 -0400
Date: Fri, 4 Jun 2010 11:27:34 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Carl Worth <cworth@cworth.org>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Commit cfecde435dda78248d6fcdc424bed68d5db6be0b turns screen
 blank
Message-ID: <20100604152734.GB19468@elliptictech.com>
Mail-Followup-To: Jeff Chua <jeff.chua.linux@gmail.com>,
	Carl Worth <cworth@cworth.org>, Eric Anholt <eric@anholt.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.1006041552280.2417@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1006041552280.2417@boston.corp.fedex.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:00 Fri 04 Jun     , Jeff Chua wrote:
> The following commit causes screen to become blank. Upon boot up, screen 
> becomes blank (monitor can't sync to pc) with i915 compiled in the 
> kernel. With i915 as module, system boots up fine, but becomes blank as 
> soon as the module is loaded.
> 
> Reverting it solves the problem. Problem only happens only Dell Optiplex 
> 780 with external LCD. But, works fine on Lenovo X201s internal LCD.

> commit cfecde435dda78248d6fcdc424bed68d5db6be0b

I imagine this is the same as the problem reported here:

  http://lkml.org/lkml/2010/6/2/249

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
