Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab0LUShL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:37:11 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:48311 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460Ab0LUShH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:37:07 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 21 Dec 2010 19:36:48 +0100
To: Chris Bagwell <chris@cnpbagwell.com>
Cc: Chase Douglas <chase.douglas@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Input: synaptics - add multi-finger and semi-mt
 support
Message-ID: <20101221183648.GA1874@polaris.bitmath.org>
References: <1292852364-19127-1-git-send-email-rydberg@euromail.se>
 <1292852364-19127-3-git-send-email-rydberg@euromail.se>
 <4D10D75D.80400@canonical.com>
 <20101221165956.GA28702@polaris.bitmath.org>
 <AANLkTi=rxBMDB+JKLY9A4iMZEtCBGNhfJxAERMb4CEjR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=rxBMDB+JKLY9A4iMZEtCBGNhfJxAERMb4CEjR@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PV74y-0001xI-8Q.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PV74y-0001xI-8Q 61ee93b4245cd8bc1a73a80f787505b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yes - the MT_TOOLs are only emitted when explicitly set in absbit, but
> > the internal interface always handles it. This is actually documented
> > in the code (and DocBook).
> 
> That note is good guidance for developer side.  Its also worth noting
> on app side that MT_TOOL_FINGER is a little special since its value is
> 0.  In most common case, I think it will get filtered out where as
> BTN_TOOL_FINGER will always be sent.
> 
> Since we can't yet query per slot ABS_MT_TOOL_TYPE, I guess apps have
> to just assume its a finger unless told otherwise?

Yes - but this is actually done for every ABS value already, so it
just follows the standard transfer method.

Thanks,
Henrik
