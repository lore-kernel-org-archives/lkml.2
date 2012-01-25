Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab2AYWxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:53:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab2AYWxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:53:37 -0500
Subject: Re: [RFCv2 00/14]
From: Mark Salter <msalter@redhat.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, Milton Miller <miltonm@bga.com>,
        benh@kernel.crashing.org, Rob Herring <rob.herring@calxeda.com>
Date: Wed, 25 Jan 2012 17:53:29 -0500
In-Reply-To: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
References: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1327532011.24169.6.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-23 at 14:07 -0700, Grant Likely wrote:
> Hey everyone,
> 
> Here's the second RFC for the irq_domain patches.  I could use some
> help testing now.  I still expect there will be a few bugs.  The
> series is based on v3.3-rc1, and I've pushed it out to my git server:

Hi Grant,

I converted arch/c6x over to the generic irq_domain support and have not
had any problems in testing. The c6x virtual irq support was a nearly
identical copy of the powerpc code, so the patch I ended up with mostly
copied what you did in arch/powerpc. The c6x patch is on the tip of:

  git@linux-c6x.org:/git/projects/linux-c6x-upstreaming irq-testing

I think this probably belongs in your series, but I can push it
separately if not.

--Mark


