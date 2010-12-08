Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab0LHQqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:46:06 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:65321 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab0LHQqD (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 8 Dec 2010 11:46:03 -0500
Date: Wed, 8 Dec 2010 11:45:52 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dave Airlie <airlied@redhat.com>
Cc: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC PATCH] Utilize the PCI API in the AGP framework.
Message-ID: <20101208164552.GA18844@dumpdata.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
 <1291680126.8232.5.camel@clockmaker-el6>
 <20101207004844.GA31478@dumpdata.com>
 <1291684609.8232.8.camel@clockmaker-el6>
 <20101207021227.GA31774@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101207021227.GA31774@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think most of them do touch PCIe cards. I swore that there were
> some AGP users out there, maybe they aren't on those bugs - let me search
> my mail archive. Maybe it just me who still uses AGP...

Ah, found three individuals :-) If none of them strongly object I am going
to freeze the AGP patchset and not bother with it for upstreaming.
> > 
> > Now if we have fixes for TTM/nouveau/radeon that make it work under Xen
> > then that is a whole different story, however these patches are not
> > those.
> 
> Nope. I just posted them: https://lkml.org/lkml/2010/12/6/516

Dave,

If you have some time, I would very much appreciate you looking over those
TTM patches. I hope they are sane enough, and any recommendation on how to
make them even better would be quite appreciated.
