Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab1DEALE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 20:11:04 -0400
Received: from gw0.danplanet.com ([71.245.107.82]:46450 "EHLO
	mail.danplanet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750846Ab1DEALB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 20:11:01 -0400
X-Greylist: delayed 1722 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Apr 2011 20:11:01 EDT
From: Dan Smith <danms@us.ibm.com>
To: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Cc: Nathan Lynch <ntl@pobox.com>, containers@lists.linux-foundation.org,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] Core checkpoint/restart support code
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
	<1298936432-29607-6-git-send-email-ntl@pobox.com>
	<20110403190324.GD15044@hallyn.com> <1301929228.31531.39.camel@tp-t61>
	<20110404151017.GA4857@hallyn.com> <1301931608.31531.49.camel@tp-t61>
	<20110404162753.GA3456@hallyn.com> <4D9A00B1.2080002@cs.columbia.edu>
	<1301953409.31531.130.camel@tp-t61>
	<20110404220309.GA10229@peq.hallyn.com>
Date: Mon, 04 Apr 2011 16:42:16 -0700
In-Reply-To: <20110404220309.GA10229@peq.hallyn.com> (Serge E. Hallyn's
	message of "Mon, 4 Apr 2011 17:03:09 -0500")
Message-ID: <87vcyt4m93.fsf@caffeine.danplanet.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SH> The API for starting a checkpoint, that I'm not on the fence on.

Is that just because it requires a C/R aware container init or for some
other reason?  I think the stricter API is a lot easier to understand,
but maybe there's something we can do to avoid that as a hard
requirement?  At least until "C/R support" becomes a desirable feature
of $INIT_DE_JOUR :)

-- 
Dan Smith
IBM Linux Technology Center
email: danms@us.ibm.com
