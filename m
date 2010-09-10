Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab0IJSk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 14:40:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab0IJSk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 14:40:57 -0400
Date: Fri, 10 Sep 2010 14:40:39 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
Message-ID: <20100910184039.GK4879@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
 <1284087065-32722-5-git-send-email-ying.huang@intel.com>
 <20100910160211.GH4879@redhat.com>
 <20100910181929.4f35ab7c@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910181929.4f35ab7c@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 06:19:29PM +0200, Andi Kleen wrote:
> 
> > I am grasping for straws here, but is there a register that APEI/HEST
> > can poke to see if it generated the NMI?
> 
> HEST knows this yes.
> 
> But this is not about HEST errors, but about those without HEST
> handling.

Don't most unknown NMIs fall into the same boat, that they were not being
handled properly?

On the other hand could you use the die_notifier_chain(DIE_UNKNOWNNMI) for
the same purpose and keep the unknown_nmi_error() handler a little
cleaner?

Cheers,
Don
