Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161366Ab2JXVwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:52:06 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35562 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161224Ab2JXVwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:52:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Nishanth Menon <nm@ti.com>, linux-pm@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / OPP: Export symbols for module usage.
Date: Wed, 24 Oct 2012 23:55:56 +0200
Message-ID: <7534328.hmkjJRmVbI@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <87k3uwagby.fsf@deeprootsystems.com>
References: <1349962774-19636-1-git-send-email-nm@ti.com> <87k3uwagby.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 of October 2012 13:45:05 Kevin Hilman wrote:
> Nishanth Menon <nm@ti.com> writes:
> 
> > From: Liam Girdwood <lrg@ti.com>
> >
> > Export the OPP functions for use by driver modules.
> >
> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Cc: Kevin Hilman <khilman@ti.com>
> > Cc: linux-pm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> >
> > [nm@ti.com: expansion of functions exported]
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> > Signed-off-by: Liam Girdwood <lrg@ti.com>
> 
> Acked-by: Kevin Hilman <khilman@ti.com>

Applied to linux-pm.git/linux-next as v3.8 material.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
