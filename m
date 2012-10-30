Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934645Ab2J3VaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:30:24 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:56114 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab2J3VaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:30:22 -0400
Date: Tue, 30 Oct 2012 17:30:18 -0400 (EDT)
From: David Airlie <airlied@redhat.com>
To: =?utf-8?Q?Pawe=C5=82?= Sikora <pawel.sikora@agmk.net>
Cc: linux-kernel@vger.kernel.org, Don Morris <don.morris@hp.com>
Message-ID: <771860661.14080204.1351632618095.JavaMail.root@redhat.com>
In-Reply-To: <1528950.lfMO1YRB8m@localhost>
Subject: Re: [3.6.2] oops @ opteron server: mgag200 Fatal error during GPU
 init
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.49.207]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Friday 19 of October 2012 07:37:55 Don Morris wrote:
> > [drm:mga_vram_init] ERROR can't reserve VRAM
> 
> Hi again, small update.
> 
> i've figured out that loading uvesafb before mgag200 is causing this
> vram-reserve-error.

I think we need to kick uvesafb off like we kick efi and vesafb.

and then block it from loading afterwards.

Dave.
