Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab1IVRlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:41:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47196 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1IVRlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:41:39 -0400
Date: Thu, 22 Sep 2011 11:41:36 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2 RESEND 2] gpio-vx855: add device tree binding
Message-ID: <20110922174136.GP17168@ponder.secretlab.ca>
References: <20110916181220.E12109D401C@zog.reactivated.net>
 <20110917155615.GT3523@ponder.secretlab.ca>
 <CAMLZHHQqqs6k2i-RCSJ0YkZ2keVNPNQV9EbVccxUW1kjUq6f_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMLZHHQqqs6k2i-RCSJ0YkZ2keVNPNQV9EbVccxUW1kjUq6f_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 10:27:07AM +0100, Daniel Drake wrote:
> Hi Grant,
> 
> Thanks for looking at this.
> 
> On Sat, Sep 17, 2011 at 4:56 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> > drivers/mfd/vx855.c should be modified to assign pdev->of_node, which
> > can be used here for setting up c->of_node.
> 
> There doesn't seem to be any obvious place in mfd/vx855.c to insert
> this. All the platform device creation and addition is done inside the
> mfd layer (e.g. mfd_add_device()). Should I look at extending the MFD
> API to allow for of_nodes to be passed in?

yes.

g.

