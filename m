Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937460Ab0CPG6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 02:58:33 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:45448 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab0CPG6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 02:58:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=gwO6SzH+njGT8QuI3ty3oJUHuB4kDEEKpJnzrnQpCJiyOJH4bTRJYSKSvQ5m1tTSIO
         A5omVCt/V76C7O5jf8Y7ddlOI7Z/+JZGMPBduaP4M36ihmY5g8dOYU+ju7tov34N29Jy
         zpqHvC3YbtuE8C2XCwu6mWvH1Hws3SoXt4giE=
MIME-Version: 1.0
In-Reply-To: <20100316061718.GA22651@elte.hu>
References: <4B990496.4020002@kernel.org> <4B9F08AC.9030904@kernel.org>
	 <20100316061718.GA22651@elte.hu>
Date: Tue, 16 Mar 2010 08:58:31 +0200
X-Google-Sender-Auth: cf183fc80eb58f9d
Message-ID: <84144f021003152358r41a79ccaxb18cf6368911266@mail.gmail.com>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 8:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
> Also, why should we make this opt-in and expose a wide range of configs to
> build breakages? A more gradual approach would be to write a simple script
> that adds a slab.h include to all .c's that include percpu.h, directly or
> indirectly.

I am all for untangling the #include mess in slab.h and friends and I
think Ingo's suggestion is probably the best way forward. We should
avoid creating tree-wide breakage for this kind of cleanups.

                        Pekka
