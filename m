Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab2HXDFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 23:05:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51046 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab2HXDFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 23:05:22 -0400
Date: Fri, 24 Aug 2012 11:05:03 +0800
From: Adam Lee <adam8157@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Yaakov Selkowitz <yselkowitz@users.sourceforge.net>,
        Peter Foley <pefoley2@verizon.net>, Paul Bolle <pebolle@tiscali.nl>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "open list:KCONFIG" <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] kconfig: replace 'oldnoconfig' with 'olddefconfig', what
 it really does
Message-ID: <20120824030503.GB5323@adam-laptop>
References: <1345187778-19678-1-git-send-email-adam8157@gmail.com>
 <1345752601.12440.3.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345752601.12440.3.camel@gandalf.local.home>
X-PGP-Key-ID: 2F39D84D
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 04:10:01PM -0400, Steven Rostedt wrote:
> Sorry for the late reply.
> 
> On Fri, 2012-08-17 at 15:16 +0800, Adam Lee wrote:
> > As 67d34a6a391369269a2e5dba8a5f42cc4cd50231 said, 'oldnoconfig' doesn't
> > set new symbols to 'n', but instead sets it to their default values.
> > 
> > So, this patch replace 'oldnoconfig' with 'olddefconfig', stop making
> > people confused.
> > 
> > PS: the document in conf.c fixed in another mail, "[PATCH] [Signed-off]
> > kconfig: document oldnoconfig to what it really does in conf.c"
> 
> The reason that I didn't make this change myself is that I'm afraid that
> things depend on 'oldnoconfig' existing. For example, ktest.pl has it
> hardcoded. That may not be the only script that uses it.

Yes, but I think very few scripts use it up to now, because it's
"fresh".

> I think a better solution would be to make oldnoconfig do just that, set
> everything to 'n' as the name implies, and we can create a olddefconfig
> to do what it does now.

Lots of configs can't be set to 'n', they expect digit or other string.

Later we fix it, bigger the problem becomes.

-- 
Regards,
Adam Lee
http://adam8157.info
