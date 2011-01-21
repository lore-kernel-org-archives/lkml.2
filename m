Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab1AUS1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:27:18 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57285 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab1AUS1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:27:15 -0500
Date: Fri, 21 Jan 2011 16:27:49 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Pavan Savoy <pavan_savoy@sify.com>
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Subject: Re: [RFC 0/2] remove BT references from TI_ST
Message-ID: <20110121182749.GE2400@joana>
References: <1294138788-10307-1-git-send-email-pavan_savoy@ti.com>
 <AANLkTinPC-i2xi9pCQ-RzGWuwZ5uTM3NXG7y6gwTnPYv@mail.gmail.com>
 <20110121171857.GC2400@joana>
 <AANLkTimGNjfMtf+6XBMfKHo_F0sEnAJVdWjobfxDWoe7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimGNjfMtf+6XBMfKHo_F0sEnAJVdWjobfxDWoe7@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavan,

* Pavan Savoy <pavan_savoy@sify.com> [2011-01-21 23:10:28 +0530]:

> >> > If this is alright, I will send out a modified patch with updated
> >> > subject to lkml/Greg for linux-next.
> >
> > Ok. Go ahead. Then tell me when I'll be able to apply your patch. (I need to
> > have the core modifications in my tree first). Or I just ack the patch and it
> > finds its way to mainline through Greg's tree.
> 
> Yes, I will post a patch to lkml against linux-next to greg KH, and
> based on that send a
> separate patch to linux-bluetooth for the btwilink..

Actually send everything to Greg KH, will work out better. Otherwise you will
have to one release cycle to merge it here (until the other patches reach my
tree). Then I just Ack it.

-- 
Gustavo F. Padovan
http://profusion.mobi
