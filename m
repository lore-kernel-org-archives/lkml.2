Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0IAQ6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 12:58:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21896 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab0IAQ57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 12:57:59 -0400
Date: Wed, 1 Sep 2010 09:57:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH next&mainline] oprofile: fix build when CONFIG_PM is
 disabled
Message-Id: <20100901095708.c1027a98.randy.dunlap@oracle.com>
In-Reply-To: <20100901165002.GN22783@erda.amd.com>
References: <20100901133614.2580f238.sfr@canb.auug.org.au>
	<20100901094132.e734ad94.randy.dunlap@oracle.com>
	<20100901165002.GN22783@erda.amd.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Sep 2010 18:50:02 +0200 Robert Richter wrote:

> On 01.09.10 12:41:32, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Using do/while for a function-returning-a-value does not
> > make gcc happy, so change it to a static inline function.
> > (happens when CONFIG_PM is not enabled)
> > 
> > arch/x86/oprofile/nmi_int.c:784: error: expected expression before 'do'
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> I already sent a fix to Ingo that fixes this.
> 
> Will update my for-next branch as soon as it is applied in tip.

Good.

But I looked at oprofile.git and didn't see any such patch.
Did I miss it there?  Can you point me to it, please?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
