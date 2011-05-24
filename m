Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab1EXTAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:00:23 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12067 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab1EXTAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:00:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 24 May 2011 12:00:22 -0700
Subject: Re: [PATCH 1/2] power: bq20z75: support external notification
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: "bleung@google.com" <bleung@google.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110524185802.GA10075@oksana.dev.rtsoft.ru>
References: <1305846004-11895-1-git-send-email-rklein@nvidia.com>
	 <20110524185802.GA10075@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 11:58:40 -0700
Message-ID: <1306263520.31129.4.camel@rklein-linux2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 11:58 -0700, Anton Vorontsov wrote:
> On Thu, May 19, 2011 at 04:00:03PM -0700, Rhyland Klein wrote:
> [...]
> > +	INIT_DELAYED_WORK(&bq20z75_device->work, bq20z75_delayed_work);
> > +
> > +	bq20z75_device->enable_detection = true;
> 
> Um... I don't follow this part.
> 
> Especially considerting that the next patch just removes this line,
> but says that it "enables detection after registering". Hm.
> 
> It says "need to enable detection" and removes "enable_detection = true".
> 
> Could you explain what's going on here? :-)
> 
> Thanks,
> 

I messed up my patches, sorry about the confusion. The first patch
wasn't supposed to add it and the second was going to do it. Let me
refresh the patches and resend them. Sorry again.

-rhyland


