Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034Ab2CMWR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:17:26 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5457 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999Ab2CMWRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:17:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 13 Mar 2012 15:17:23 -0700
Subject: Re: [PATCH] ASoC: max98095: add jack detection
From: Rhyland Klein <rklein@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Peter Hsiang <cdefgab1288@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20120313221235.GJ3177@opensource.wolfsonmicro.com>
References: <1331667848-8168-1-git-send-email-rklein@nvidia.com>
	 <20120313221235.GJ3177@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Mar 2012 15:18:17 -0700
Message-ID: <1331677097.9410.8.camel@rklein-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 15:12 -0700, Mark Brown wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Mar 13, 2012 at 12:44:08PM -0700, Rhyland Klein wrote:
> > This change adds the logic to support using the jack detect mechanism built
> > in to the codec to detect both when a jack was inserted and what type of
> > jack is present.
> 
> You send another identically titled patch of roughly the same size a
> few minutes ago - what's the difference between the two or is it just a
> resend?

Sorry, they are the same. I hadn't subscribed to the alsa-devel mailing
list and so the first one I sent got as non-subscriber sent email. I
canceled the outstanding notice waiting for approval, and resent once I
subscribed to the mailing list.

-rhyland

> 
> * Unknown Key
> * 0x6E30FDDD


