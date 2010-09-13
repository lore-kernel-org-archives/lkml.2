Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab0IMNjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:39:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:4704 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab0IMNjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:39:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,359,1280732400"; 
   d="scan'208";a="606429523"
Date: Mon, 13 Sep 2010 15:39:52 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Douglas Schilling Landgraf <dougsland@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND][PATCH 0/2] media, mfd: Add timberdale video-in driver
Message-ID: <20100913133951.GD2555@sortiz-mobl>
References: <1283428572.23309.24.camel@debian>
 <4C87E67E.2040807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C87E67E.2040807@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Wed, Sep 08, 2010 at 04:39:42PM -0300, Mauro Carvalho Chehab wrote:
> Em 02-09-2010 08:56, Richard Röjfors escreveu:
> > To follow are two patches.
> > 
> > The first adds the timberdale video-in driver to the media tree.
> > 
> > The second adds it to the timberdale MFD driver.
> > 
> > Samuel and Mauro hope you can support and solve the potential merge
> > issue between your two trees.
> 
> If the conflicts are trivial, I can handle when merging upstream.
Since the mfd part of this patchset has a build time dependency on the media
part, would you mind pushing both patches upstream through your tree ?
I'll ACK the mfd part.

Cheers,
Samuel.


> > 
> > Thanks
> > --Richard
> > 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
