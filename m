Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964965Ab2CEPKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:10:44 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:34961 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964934Ab2CEPKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:10:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.68.234.131 as permitted sender) smtp.mail=glikely@secretlab.ca
Date: Mon, 5 Mar 2012 08:10:42 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] devicetree: Add empty of_platform_populate() for
 !CONFIG_OF_ADDRESS (sparc)
Message-ID: <20120305151042.GD27229@ponder.secretlab.ca>
References: <1330121218-10442-1-git-send-email-grant.likely@secretlab.ca>
 <4F513990.1030401@ti.com>
 <20120302170715.9f0a67ef.akpm@linux-foundation.org>
 <20120303040930.1E9283E190C@localhost>
 <4F54BFD9.8000802@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F54BFD9.8000802@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 02:30:01PM +0100, Cousson, Benoit wrote:
> On 3/3/2012 5:09 AM, Grant Likely wrote:
> >On Fri, 2 Mar 2012 17:07:15 -0800, Andrew Morton<akpm@linux-foundation.org>  wrote:
> >>All twl is broken.  i386 allmodconfig with this monring's linux-next:
> >>
> >>drivers/mfd/twl-core.c: In function 'twl_probe':
> >>drivers/mfd/twl-core.c:1357: error: implicit declaration of function 'of_platform_populate'
> >>
> >
> >This patch seems to solve it finally against irqdomain/next.  Benoit, with
> >your ack I'll push it out.
> 
> I've just built it on x86 and tested it on OMAP4 board successfully.
> 
> Acked-by: Benoit Cousson <b-cousson@ti.com>

Okay, I've pushed it out.

g.
