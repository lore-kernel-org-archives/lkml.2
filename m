Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab1DECR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 22:17:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51266 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab1DECRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 22:17:19 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=wom5GMh1gUkA:10 a=qfFVHXmYx5UA:10 a=kj9zAlcOel0A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:17 a=VnNF1IyMAAAA:8 a=eQx54m0IHPEuaUsJkCoA:9 a=CjuIK1q_8ugA:10 a=eAWTIsOZi86Vnn5xZOjC/w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.154.172
Date: Mon, 4 Apr 2011 21:17:16 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Dan Smith <danms@us.ibm.com>
Cc: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Nathan Lynch <ntl@pobox.com>,
        containers@lists.linux-foundation.org,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] Core checkpoint/restart support code
Message-ID: <20110405021716.GA16672@hallyn.com>
References: <1298936432-29607-6-git-send-email-ntl@pobox.com>
 <20110403190324.GD15044@hallyn.com>
 <1301929228.31531.39.camel@tp-t61>
 <20110404151017.GA4857@hallyn.com>
 <1301931608.31531.49.camel@tp-t61>
 <20110404162753.GA3456@hallyn.com>
 <4D9A00B1.2080002@cs.columbia.edu>
 <1301953409.31531.130.camel@tp-t61>
 <20110404220309.GA10229@peq.hallyn.com>
 <87vcyt4m93.fsf@caffeine.danplanet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vcyt4m93.fsf@caffeine.danplanet.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dan Smith (danms@us.ibm.com):
> SH> The API for starting a checkpoint, that I'm not on the fence on.
> 
> Is that just because it requires a C/R aware container init or for some

Yup, that's it.

Which is why I'd be fine with it as a short-term workaround, if it might
actually help with upstreaming.

-serge
