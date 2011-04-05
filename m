Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab1DETTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 15:19:07 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:33199 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab1DETTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 15:19:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:from:to
	:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=sasl; b=dhjtEW
	cDMBEhDhksP2zSv6cwncXSY1X4WDV5+MJFuRsLKPQD870cEQAQOzkHOzpnJm6qRb
	ecRe0nTEr4r7QoZ9OkEjE+9efzFNXEFVoXR0IAARM7xSTbzNXBBhOcna2/Rc9AXK
	1q/W/DyWEETNq59abvfVMK1yPcFKcZ44LVWO0=
Subject: Re: [PATCH 05/10] Core checkpoint/restart support code
From: Nathan Lynch <ntl@pobox.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Dan Smith <danms@us.ibm.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        containers@lists.linux-foundation.org,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110405021716.GA16672@hallyn.com>
References: <1298936432-29607-6-git-send-email-ntl@pobox.com>
 <20110403190324.GD15044@hallyn.com> <1301929228.31531.39.camel@tp-t61>
 <20110404151017.GA4857@hallyn.com> <1301931608.31531.49.camel@tp-t61>
 <20110404162753.GA3456@hallyn.com> <4D9A00B1.2080002@cs.columbia.edu>
 <1301953409.31531.130.camel@tp-t61> <20110404220309.GA10229@peq.hallyn.com>
 <87vcyt4m93.fsf@caffeine.danplanet.com> <20110405021716.GA16672@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 14:18:46 -0500
Message-ID: <1302031126.6424.8.camel@tp-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: CF8F0226-5FB9-11E0-B21B-E8AB60295C12-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 21:17 -0500, Serge E. Hallyn wrote:
> Quoting Dan Smith (danms@us.ibm.com):
> > SH> The API for starting a checkpoint, that I'm not on the fence on.
> > 
> > Is that just because it requires a C/R aware container init or for some
> 
> Yup, that's it.
> 
> Which is why I'd be fine with it as a short-term workaround, if it might
> actually help with upstreaming.

Okay, I'll look at making unmodified init work.  One possibility is to
run the distro init as a child of the c/r-aware init, I suppose.


