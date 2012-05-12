Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab2ELOdV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 10:33:21 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:5172 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547Ab2ELOdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 10:33:19 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host q4CEWDVx022661
Subject: Re: [PATCH] unmapped quotes
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, liwp.linux@gmail.com,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Date: Sat, 12 May 2012 16:32:14 +0200
In-Reply-To: <20120512112637.GA11577@localhost>
References: <y> <4fae23ca.68db440a.4bc9.22cc@mx.google.com>
	 <4FAE272C.6080804@msgid.tls.msk.ru> <20120512112637.GA11577@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1336833136.14918.12.camel@thorin>
Mime-Version: 1.0
X-DCC-dcc1-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sam, 2012-05-12 at 19:26 +0800, Fengguang Wu wrote:
> On Sat, May 12, 2012 at 01:02:36PM +0400, Michael Tokarev wrote:
> > On 12.05.2012 12:47, liwp.linux@gmail.com wrote:
> > > - * If we're over `background_thresh' then the writeback threads are woken to
> > > + * If we're over 'background_thresh' then the writeback threads are woken to
> > 
> > I can't say the original is wrong.  Since these quotes don't have
> > "open" and "close" versions like {} or () pairs does, people often
> > use ` as opening and ' as closing - while staying within ascii.
> > Alternatives are things like « » or other things, but these aren't
> > ascii anymore.  So I'd say keep it alone... ;)
> 
> Agreed. For example, latex uses ` and ' as opening and closing pairs.

m4 too.

> That does look a bit weird for C and shell users ;)

Just because they aren't used to it;-)
And shell scripting would be easier if shells had different opening and
closing quote characters.

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

