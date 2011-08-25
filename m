Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab1HYSTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 14:19:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab1HYSTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 14:19:40 -0400
Date: Thu, 25 Aug 2011 20:19:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Roland Stigge <stigge@antcom.de>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "mkuboot.sh: Fail if mkimage is missing"
In-Reply-To: <4E564417.10304@antcom.de>
Message-ID: <alpine.LNX.2.00.1108252019270.13644@pobox.suse.cz>
References: <alpine.LNX.2.00.1108251353050.13644@pobox.suse.cz> <4E564417.10304@antcom.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011, Roland Stigge wrote:

> Hi,
> 
> On 08/25/2011 01:53 PM, Jiri Kosina wrote:
> > It causes the whole build to fail when mkimage is not found. This doesn't
> > seem right, as the failure is not fatal for the rest of the build.
> 
> I disagree. As I understand, mkimage is only used on "make uImage". When
> I do this and the tool producing the uImage (i.e. the final target) is
> missing or can't produce the target otherwise, I expect an error.
> Otherwise, this problem would be silently ignored. That's why I created
> the original patch in the first place.
> 
> Please tell me if I missed come fact.

Right you are. Sorry for the noise.

-- 
Jiri Kosina
SUSE Labs
