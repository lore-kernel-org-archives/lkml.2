Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab0J1JAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 05:00:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55561 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab0J1JAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 05:00:14 -0400
Date: Thu, 28 Oct 2010 11:00:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: 2.6.36 io bring the system to its knees
Message-ID: <20101028090002.GA12446@elte.hu>
References: <AANLkTimt7wzR9RwGWbvhiOmot_zzayfCfSh_-v6yvuAP@mail.gmail.com>
 <AANLkTikRKVBzO=ruy=JDmBF28NiUdJmAqb4-1VhK0QBX@mail.gmail.com>
 <AANLkTinzJ9a+9w7G5X0uZpX2o-L8E6XW98VFKoF1R_-S@mail.gmail.com>
 <AANLkTinDDG0ZkNFJZXuV9k3nJgueUW=ph8AuHgyeAXji@mail.gmail.com>
 <AANLkTikvSGNE7uGn5p0tfJNg4Hz5WRmLRC8cXu7+GhMk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikvSGNE7uGn5p0tfJNg4Hz5WRmLRC8cXu7+GhMk@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@kernel.org> wrote:

> On Thu, Oct 28, 2010 at 9:09 AM, Aidar Kultayev <the.aidar@gmail.com> wrote:
> > Find attached screenshot ( latencytop_n_powertop.png ) which depicts
> > artifacts where the window manager froze at the time I was trying to
> > see a tab in Konsole where the powertop was running.
> 
> You seem to have forgotten to include the attachment.

I got it - it appears it was too large for lkml's ~500K mail size limit.

Aidar, mind sending a smaller image?

Thanks,

	Ingo
