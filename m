Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab1EKQfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:35:09 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:60028 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257Ab1EKQOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:14:48 -0400
Date: Wed, 11 May 2011 15:48:17 +0200
From: Borislav Petkov <bp@amd64.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf: Carve out cgroup-related code
Message-ID: <20110511134817.GB25827@aftab>
References: <1305119816-26280-1-git-send-email-bp@amd64.org>
 <1305119816-26280-2-git-send-email-bp@amd64.org>
 <20110511133340.GB1846@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511133340.GB1846@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 09:33:43AM -0400, Frederic Weisbecker wrote:
> BTW, before you do it yourself, I have a patch pending that splits the buffer
> part from the core.

Cool. But no, callchain.c and cgroup.c were the low hanging fruits I saw
so I have no plans for the buffer part. Go ahead and send it too.

> Just to avoid effort duplicates... :)

Yep.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
