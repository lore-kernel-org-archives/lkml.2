Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1C2H0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 03:26:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58963 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab1C2H0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 03:26:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dV6gE48SVMJeJU0XtWJTF4VrI03R+UgnuyFeilT3eLtqNLN5iZnE2V390Uja8+T8up
         HccEcycvBck4L2v/D1si1/99hecg+638CdwclbHsyZgwXXI6DLnpipEoYrSpOwaKu+8i
         UsTlxAYzT6vd8eJeOxDM5moMCFrOYkXRWT1H8=
MIME-Version: 1.0
In-Reply-To: <20110328215344.GC3008@dastard>
References: <AANLkTinFqqmE+fTMTLVU-_CwPE+LQv7CpXSQ5+CdAKLK@mail.gmail.com>
	<20110328215344.GC3008@dastard>
Date: Tue, 29 Mar 2011 11:26:00 +0400
Message-ID: <AANLkTi==vw7Dy-oK31PxHadwUaDRUUk+TM0ECSZ=chfv@mail.gmail.com>
Subject: Re: Very aggressive memory reclaim
From: John Lepikhin <johnlepikhin@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/29 Dave Chinner <david@fromorbit.com>:

> First it would be useful to determine why the VM is reclaiming so
> much memory. If it is somewhat predictable when the excessive
> reclaim is going to happen, it might be worth capturing an event
> trace from the VM so we can see more precisely what it is doiing
> during this event. In that case, recording the kmem/* and vmscan/*
> events is probably sufficient to tell us what memory allocations
> triggered reclaim and how much reclaim was done on each event.

Do you mean I must add some debug to mm functions? I don't know any
other way to catch such events.
