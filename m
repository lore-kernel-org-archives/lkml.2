Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab0IFLYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 07:24:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40416 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab0IFLYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 07:24:51 -0400
Subject: Re: disabling group leader perf_event
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4C84B088.5050003@redhat.com>
References: <4C84B088.5050003@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Sep 2010 13:24:16 +0200
Message-ID: <1283772256.1930.303.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-06 at 12:12 +0300, Avi Kivity wrote:
> If I read the code correctly, disabling a group leader perf_event will 
> disable the entire group.
> 
> Is this correct?

Yeah, pretty much.

> If so, how can I disable just the event itself?  Can I allocate a dummy 
> invent for the group leader so I can enable and disable each perf_event 
> in the group individually?

Which makes me wonder why you use groups in the first place.
