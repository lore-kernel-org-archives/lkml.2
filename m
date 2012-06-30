Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab2F3SSJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 14:18:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41882 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab2F3SSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 14:18:07 -0400
MIME-Version: 1.0
In-Reply-To: <1341062406.1911.76.camel@x61.thuisdomein>
References: <1340786187.1911.24.camel@x61.thuisdomein>
	<1341062406.1911.76.camel@x61.thuisdomein>
Date: Sat, 30 Jun 2012 21:18:04 +0300
Message-ID: <CANUX_P3kypkUv+-meABAOGa6GQ9cR5ugySJj+SjvVfCykCQuYQ@mail.gmail.com>
Subject: Re: [PATCH] iwlegacy: print how long queue was actually stuck
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> On Wed, 2012-06-27 at 10:36 +0200, Paul Bolle wrote:
> > Every now and then, after resuming from suspend, the iwlegacy driver
> > prints
> >     iwl4965 0000:03:00.0: Queue 2 stuck for 2000 ms.
> >     iwl4965 0000:03:00.0: On demand firmware reload
> >
> > I have no idea what causes these errors. But the code currently uses
> > wd_timeout in the first error. wd_timeout will generally be set at
> > IL_DEF_WD_TIMEOUT (ie, 2000). Perhaps printing for how long the queue
> > was actually stuck can clarify the cause of these errors.
>

You may want to try this one:
http://www.spinics.net/lists/stable-commits/msg18110.html
