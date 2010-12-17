Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab0LQV6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 16:58:41 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:33735 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753394Ab0LQV6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 16:58:40 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 17 Dec 2010 22:58:15 +0100
To: Andy Ross <andy@plausible.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] WeTab device ID
Message-ID: <20101217215815.GA3800@polaris>
References: <4D0AA66F.6080506@plausible.org>
 <20101217120322.GA3873@polaris>
 <4D0BD443.1070803@plausible.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0BD443.1070803@plausible.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PTiJh-0007uI-BT.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PTiJh-0007uI-BT 0465672cfa38165fede9c3a75f2dcdb7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 01:21:07PM -0800, Andy Ross wrote:
> On 12/17/2010 04:03 AM, Henrik Rydberg wrote:
> > Thanks for the patch. Does the one below work for you?
> 
> Looks like this is against more recent changes than I see in the "hid"
> branch of input-mt on kernel.org.  I don't see a
> "...EGALAX_MULTITOUCH3" defined there.  Maybe you missed a push?  So
> not tested as-is, but certainly looks correct by inspection.

Ah, the tip is actually at the next branch, never did say that.

Thanks,
Henrik
