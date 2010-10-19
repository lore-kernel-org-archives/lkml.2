Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab0JSQCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:02:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643Ab0JSQCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:02:19 -0400
Date: Tue, 19 Oct 2010 12:01:58 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>
Subject: Re: [PATCH 5/5] x86, NMI: Remove do_nmi_callback logic
Message-ID: <20101019160158.GM4140@redhat.com>
References: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
 <1287195738-3136-6-git-send-email-dzickus@redhat.com>
 <20101019150303.GQ5969@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019150303.GQ5969@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 05:03:03PM +0200, Robert Richter wrote:
> > +++ b/arch/x86/kernel/traps.c
> > @@ -83,6 +83,8 @@ EXPORT_SYMBOL_GPL(used_vectors);
> >  
> >  static int ignore_nmis;
> >  
> > +int unknown_nmi_panic;
> 
> I didn't apply the patches, so I am not really sure, but I think this
> could be static now.

It is used in kernel/sysctl.c so I don't think it can.

Cheers,
Don
