Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab1DDVjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 17:39:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46716 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab1DDVjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 17:39:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GslJzPps1y8eRsUu63GuPgr6kPFg2yuAp6X7c0gAM3CYmz+KDOS93BO5bMN3Z8Up84
         5w1GTmAPncWjtxQwTALsKoaOKHrRYvRcJVMenD5ZM2CzF1RFN78bkit8X6VTf67oFlLl
         wcqMbXCuC0lZcUjV6GOP4b34nKfgQiU6HjbG0=
Date: Mon, 4 Apr 2011 14:39:10 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Jeffrey Brown <jeffbrown@android.com>, Jiri Kosina <jkosina@suse.cz>,
        Henrik Rydberg <rydberg@euromail.se>, Simon Budig <simon@budig.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] hid-magicmouse: Increase evdev buffer size
Message-ID: <20110404213910.GD984@core.coreip.homeip.net>
References: <1301691819-2090-1-git-send-email-chase.douglas@canonical.com>
 <AANLkTim-tN=siA8tJVCzNZHs+oM0hN-N8Ckc+9ynnNpb@mail.gmail.com>
 <alpine.LNX.2.00.1104041441530.28516@pobox.suse.cz>
 <BANLkTikG-ku9mDebcaPKTwv3X0N+OKiyYQ@mail.gmail.com>
 <4D9A1407.6030308@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9A1407.6030308@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 02:55:03PM -0400, Chase Douglas wrote:
> On 04/04/2011 02:13 PM, Jeffrey Brown wrote:
> > On Mon, Apr 4, 2011 at 5:43 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> >> I'd happuly take Chase's patch, but want to make sure that we don't cause
> >> any changes that would make backwards compatilibity an issue later.
> > 
> > There should be no compatibility issues.  However, we might be better
> > off in the long term taking (some variation of) these patches instead.
> 
> I like the proposed changes, but I want to ensure stable kernel releases
> aren't left out of the fix for hid-magicmouse. I don't know the best way
> forward, but here's one possibility:
> 
> 1. Apply my patch to manually set the buffer size hint
> 2. It gets sent to stable trees due to the 'Cc: stable@kernel.org' line
> 3. Apply Jeffrey's patches, including a reversion of my buffer size hint
> 
> Obviously the extra application and reversion is odd, but this seems the
> easiest way forward given that the patches already exist and can be
> applied without issue.
> 

Or, once Jeffrey's patches hit mainline, send your change to stable with
the explanation why it is needed for stable but not for mainline.

Thanks.

-- 
Dmitry
