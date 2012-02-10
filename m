Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab2BJGSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 01:18:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:54066 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2BJGSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 01:18:37 -0500
Message-ID: <1328854519.3019.3.camel@pasglop>
Subject: Re: [PATCH] perf_events: fix broken intr throttling (v3)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Stephane Eranian <eranian@google.com>, Anton Blanchard <anton@samba.org>,
        linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        gleb@redhat.com, wcohen@redhat.com, vince@deater.net, asharma@fb.com,
        andi@firstfloor.org, paulus@samba.org, emunson@mgebm.net,
        imunsie@au1.ibm.com
Date: Fri, 10 Feb 2012 17:15:19 +1100
In-Reply-To: <20120210031930.GA28023@us.ibm.com>
References: <20120126160319.GA5655@quad> <20120208223250.282861cb@kryten>
	 <CABPqkBRbvs3rHoCw9najObgUvfSCziVrR-U-UARWN3+St2=v8A@mail.gmail.com>
	 <20120210031930.GA28023@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-09 at 19:19 -0800, Sukadev Bhattiprolu wrote:
> Stephane Eranian [eranian@google.com] wrote:
> | On Wed, Feb 8, 2012 at 12:32 PM, Anton Blanchard <anton@samba.org> wrote:
> | >
> | > Hi,
> | >
> | > On Thu, 26 Jan 2012 17:03:19 +0100
> | > Stephane Eranian <eranian@google.com> wrote:
> | >
> | >> This patch fixes the throttling mechanism. It was broken
> | >> in 3.2.0. Events were not being unthrottled. The unthrottling
> | >> mechanism required that events be checked at each timer tick.
> | >
> | > This patch breaks perf on POWER. I haven't had a chance to work out why
> | > yet, but will investigate tomorrow.
> | >
> | Did you apply the subsequent patch I posted yesterday:
> | 
> | https://lkml.org/lkml/2012/2/7/185
> 
> I applied both patches to the powerpc.git tree - following hunk already
> exists in the powerpc tree (and even Jan 27 mainline) so I skipped this
> hunk.

The powerpc .git tree is not useful at this point, I haven't opened
powerpc -next yet so it's just all old stale stuff. Please work with
upstream always unless you have a very good reason to use my tree. It's
really only meant as a conduit between me and Linus or for -next.

Cheers,
Ben.


