Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab2AMRJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 12:09:23 -0500
Received: from lo.gmane.org ([80.91.229.12]:55445 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab2AMRJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 12:09:21 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el.es.cr@gmail.com>
Subject: Re: HID device calibration - how to override mapping?
Date: Fri, 13 Jan 2012 17:09:01 +0000 (UTC)
Message-ID: <loom.20120113T175122-168@post.gmane.org>
References: <4F1051CA.4090007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.139.108.193 (Mozilla/5.0 (Windows NT 5.1; rv:9.0.1) Gecko/20100101 Firefox/9.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enrico Mattea <ocirne94 <at> gmail.com> writes:
(sorry for excessive trimmings, but gmane web i/f made me do it)

> 
> Hello all,
> [...]

> [...] while the clutch pedal sends 0 to -32767 to +32767 to 0 
> (from released (0) to halfway (-32767), then the value jumps to +32767, 
> then decreases again to 0 when fully pressed).

released - halfway - pressed
0 - (-32767) <-> (32767) - 0
but does it happen in reverse order when releasing pedal ?

seems the interpretation of this is up to the application really,
but /if/ the -32767 to 32767 change happens all around the 'halfway'
spot, maybe it is (in the app. engine) interpreted as 'change'
and it's effect applied to 'car engine' not directly, but integrated 
(time-integral function applied) first ? 
(or if it is the /change/ here that matters , it actually
is a /time-derivative/ that actually applies to the simulation?)

> 
> This obviously makes it impossible to properly calibrate the axis for 
> anything, because of the "jump" at halfway and of the equality of min 
> and max returned values.

I'd say, for the clutch simulation it's the /change-in-time/ that 
matters, not the /exact/ value; so no 'static' calibration is
ever going to be relevant (bar maybe the device telling us when the
pedal is fully pressed or fully released - in case app is not tracking
it)

> 
[...]
> Thank you very much in advance,
> Ocirne
> 
el es

