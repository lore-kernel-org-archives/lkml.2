Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab0ELS12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 14:27:28 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:34240 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab0ELS11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 14:27:27 -0400
Date: Wed, 12 May 2010 23:57:20 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: James Kosin <jkosin@intcomgrp.com>, Dhaval Giani <dhaval.giani@gmail.com>,
       Jan Safranek <jsafrane@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       menage@google.com, lennart@poettering.net, tglx@linutronix.de
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
Message-ID: <20100512182720.GN3296@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <eJktY-7JG-7@gated-at.bofh.it>
 <eJktY-7JG-5@gated-at.bofh.it>
 <4BEAB6FC.8090105@intcomgrp.com>
 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
 <1273674048.1626.117.camel@laptop>
 <4BEABDF8.40206@redhat.com>
 <4BEAE7A1.2010001@intcomgrp.com>
 <AANLkTikEyJ8q9GkpyZo0OUY4MLM_soWEviiBG2R6H-mY@mail.gmail.com>
 <4BEAEC2A.6090306@intcomgrp.com>
 <4BEAED98.30502@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4BEAED98.30502@nortel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Friesen <cfriesen@nortel.com> [2010-05-12 12:04:08]:

> Something I haven't tried is whether or not it's possible to set
> ownership/permissions on subtrees within the cgroup hierarchy to allow
> unprivileged users/groups to control their own tasks (basically letting
> them prioritize their own jobs without being able to affect anything
> else).  Does anyone know if this sort of thing is possible?

Yep, it is.

-- 
	Three Cheers,
	Balbir
