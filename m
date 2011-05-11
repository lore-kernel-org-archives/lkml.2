Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab1EKQ3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:29:50 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:59886 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab1EKQ3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:29:48 -0400
Date: Wed, 11 May 2011 16:02:08 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] perf: Carve out cgroup-related code
Message-ID: <20110511140208.GD25827@aftab>
References: <20110511121135.GA25865@aftab>
 <1305121600.2914.214.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305121600.2914.214.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 09:46:40AM -0400, Peter Zijlstra wrote:
> On Wed, 2011-05-11 at 14:11 +0200, Borislav Petkov wrote:
> >  include/linux/perf_event.h |  138 ++++++++++++-
> 
> I don't like exposing all that in a kernel wide header.. should we maybe
> have kernel/events/internal.h?

Sounds prudent. Maybe add a patch ontop that moves all perf_event.h
exports which are shared _only_ between kernel/events/*.c compilation
units to an internal.h header? Ingo?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
