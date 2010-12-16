Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab0LPATr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 19:19:47 -0500
Received: from leo.clearchain.com ([199.73.29.74]:33962 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab0LPATq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 19:19:46 -0500
Date: Thu, 16 Dec 2010 10:19:32 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Henrik Rydberg <rydberg@bitmath.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Chris Bagwell <chris@cnpbagwell.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Alternative approach to MT_TOOL_ENVELOPE
Message-ID: <20101216001931.GB4952@salty.local>
References: <4D0897F3.7040500@bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0897F3.7040500@bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Thu, 16 Dec 2010 10:49:37 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 11:26:59AM +0100, Henrik Rydberg wrote:
> >> Ping has touched upon this subject as well, from the pen & touch perspective.
> >> Generally, some ABS axes are actually enumerations, for which we have no
> >> direct abstraction. If we had a way to declare the used values for such
> >> enumerations, it would resolve these and possibly other issues.
> 
> > I think that presence of pen/touch can be detected by having
> > BTN_TOOL_PEN and BTN_TOOL_FINGER. However in this case the tool is
> > finger, so I do not think we should introduce BTN_TOOL_ENVELOPE. Maybe
> > this is another case where we should employ the proposed device flags?
> 
> Yes. Having something like INPUT_QUIRK_SEMI_MT might be enough, and we could
> drop the whole MT_TOOL_ENVELOPE circus. Chase, Peter, Chris, would you be
> comfortable with such a solution?

sounds good to me, thanks.

Cheers,
  Peter

> > Anyway, it looks like we have a few concerns with current
> > MT_TOOL_ENVELOPE so I want to rewind my 'next' branch.
> 
> Yep. Should I also take the opportunity to sync from -rc1 instead, and fold the
> cleanup patches into the appropriate places?
> 
> Thanks,
> Henrik
> 
