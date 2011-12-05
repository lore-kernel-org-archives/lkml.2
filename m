Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab1LENP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:15:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33991 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab1LENP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:15:26 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=bIx0b5jsXZQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=TG6r5tDwEjeJCVJ87GsA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 09/11] slab, lockdep: Fix silly bug
From: Steven Rostedt <rostedt@goodmis.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Hans Schillstrom <hans@schillstrom.com>,
        Christoph Lameter <cl@gentwo.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
        Sitsofe Wheeler <sitsofe@yahoo.com>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>
In-Reply-To: <alpine.LFD.2.02.1112051503400.8257@tux.localdomain>
References: <20111204185444.411298317@goodmis.org>
	 <20111204190021.812654254@goodmis.org>
	 <alpine.LFD.2.02.1112051503400.8257@tux.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 08:15:20 -0500
Message-ID: <1323090920.30977.72.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 15:04 +0200, Pekka Enberg wrote:

> Your emails seem to be damaged in interesting ways.

Really? I'm using quilt mail to send.

> 
> I assume the patch is going through the lockdep tree? If so, please make 
> sure you include Christoph's ACK in the changelog.

This is for the stable-rt tree. This patch is on its way, but you'll
have to talk to Peter about Acks and such.

But this brings up a point. I'll start adding [RT] to the subject of the
patches as well to not confuse people.

Thanks,

-- Steve


