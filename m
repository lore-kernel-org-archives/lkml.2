Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab1DDLl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 07:41:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59337 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294Ab1DDLl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 07:41:56 -0400
Date: Mon, 4 Apr 2011 13:41:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Unavowed <unavowed@vexillium.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Add NOGET quirk for the CH Pro Throttle
In-Reply-To: <4D999177.4010401@vexillium.org>
Message-ID: <alpine.LNX.2.00.1104041340080.28516@pobox.suse.cz>
References: <4d988b60.29c6ec0a.0716.ffffa4bf@mx.google.com> <alpine.LNX.2.00.1104041105250.28516@pobox.suse.cz> <4D999177.4010401@vexillium.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Apr 2011, Unavowed wrote:

> >> The CH Pro Throttle needs the NOGET quirk flag to work, just like other CH
> >> Products devices which already have the flag set.
> >>
> >> Signed-off-by: Unavowed <unavowed@vexillium.org>
> > 
> > Hi,
> > 
> > thanks a lot for the patch.
> > 
> > Would it please be possible to have a real name to attribute for patch 
> > authorship and Signed-off-by line?
> 
> Hi,
> 
> Thanks for such a quick response.
> 
> I'm sorry, but I only ever write contributions under a pseudonym.  Is
> this not acceptable, especially for such a trivial patch?

Well, see paragraph 12) of Documentation/SubmittingPatches. Especially the 
part with "sorry, no pseudonyms or anonymous contributions".

Now, I agree that trivial USB ID addition such as this really is 
a bit borderline ... 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
