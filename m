Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2FSIXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:23:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42698 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2FSIXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:23:49 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1340078392.6871.6.camel@deadeye.wl.decadent.org.uk>
References: <20120617175941.281333656@decadent.org.uk>
	<20120617175941.924141588@decadent.org.uk>
	<20120618215555.GD3263@herton-Z68MA-D2H-B3>
	<4FDFA760.5040403@intel.com>
	<1340078392.6871.6.camel@deadeye.wl.decadent.org.uk>
Date: Tue, 19 Jun 2012 10:23:48 +0200
Message-ID: <CAKMK7uEPNBDbBT4TEf9norZ_em9c+v89XRoFF_Yyam8pakYMOQ@mail.gmail.com>
Subject: Re: [ 04/69] drm/i915: fix up ivb plane 3 pageflips
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 5:59 AM, Ben Hutchings <ben@decadent.org.uk>
> So should I drop this until the second patch is upstream?

Nah, just merge it. It covers a truly impossible situation, and I've
decided to not push Eugeni's fixup through -fixes because if that.
Still, thanks for catching this.
-Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
