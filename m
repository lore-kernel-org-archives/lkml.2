Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab2DFRl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 13:41:27 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43428 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab2DFRl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 13:41:26 -0400
Subject: Re: [PATCH] net/core: Fix seeking in /proc/net/dev
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mihai Maruseac <mmaruseac@ixiacom.com>
Cc: John Keeping <john@keeping.me.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mihai Maruseac <mihai.maruseac@gmail.com>,
        Daniel Baluta <dbaluta@ixiacom.com>
In-Reply-To: <CAOMsUMLDFpYw9REPjZd2m49xV4UKFjFobNorGmOPCFeqjV-RDg@mail.gmail.com>
References: <1333731944-15808-1-git-send-email-john@keeping.me.uk>
	 <CAOMsUMLDFpYw9REPjZd2m49xV4UKFjFobNorGmOPCFeqjV-RDg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Apr 2012 19:41:19 +0200
Message-ID: <1333734079.3007.4.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 20:14 +0300, Mihai Maruseac wrote:
> On Fri, Apr 6, 2012 at 8:05 PM, John Keeping <john@keeping.me.uk> wrote:
> > Commit f04565ddf52e4 (dev: use name hash for dev_seq_ops) introduced
> > code that fails to check the requested position when getting an item for
> > /proc/net/dev.  This means that any code which seeks within this file is
> > likely to receive corrupted data.
> >
> > A test case for this is to use the read builtin in bash:
> >
...
> Looks good to me. However, Eric just submitted a patch here with other
> changes caused by a logic error in the original patch.

Hmm, I think my patch fixed this lseek issue as well.


