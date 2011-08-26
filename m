Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab1HZOJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:09:55 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48166 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab1HZOJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:09:54 -0400
Subject: Re: [PATCH] slab: trivial: cleanup: remove unneeded return
From: Zhao Jin <cronozhj@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com,
        trivial@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1108260211370.14732@chino.kir.corp.google.com>
References: <CADqbE94+eZPeMggwkeZsXYxmkCRddRT7OXeiEyj_b3m=g5GxUQ@mail.gmail.com>
	 <CADqbE97+FKz-7op-nmdOVmq3mrXadaxQrtk9Zud90E7iMMEUVQ@mail.gmail.com>
	 <4E573F68.1020603@gmail.com>
	 <alpine.DEB.2.00.1108260211370.14732@chino.kir.corp.google.com>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 26 Aug 2011 22:09:39 +0800
Message-ID: <1314367779.8991.16.camel@vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 02:13 -0700, David Rientjes wrote:
> On Fri, 26 Aug 2011, Zhao Jin wrote:
> 
> > Terribly sorry. It was gmail who wrapped the line.
> > Please see this following version. Thanks!
> > 
> 
> It's still whitespace damaged, please see Documentation/email-clients.txt.  
> If it doesn't help, please add to that document with whatever eventually 
> works for you, it will help many people in the future!
> 
> This probably shouldn't be cc'd to trivial, it's a candidate to go through 
> Pekka's slab tree.  And once you get the email client sorted out or Pekka 
> decides to do it manually, feel free to add my
> 
> 	Acked-by: David Rientjes <rientjes@google.com>
> 
> even though you forgot the changelog and your own signed-off-by line on 
> this one :)

email-client.txt really helps me a lot. I shall resend the patch.
Many thanks for the kind tip!

Regards,
zhj


