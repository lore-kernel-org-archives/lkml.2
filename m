Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab1DDWLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:11:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46045 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab1DDWLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:11:23 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=wom5GMh1gUkA:10 a=qfFVHXmYx5UA:10 a=kj9zAlcOel0A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:17 a=Z4Rwk6OoAAAA:8 a=KwWQQSdE4F3juHBmBowA:9 a=CjuIK1q_8ugA:10 a=jbrJJM5MRmoA:10 a=eAWTIsOZi86Vnn5xZOjC/w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.154.172
Date: Mon, 4 Apr 2011 17:11:21 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        containers@lists.linux-foundation.org, Nathan Lynch <ntl@pobox.com>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 05/10] Core checkpoint/restart support code
Message-ID: <20110404221121.GA30213@hallyn.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
 <1298936432-29607-6-git-send-email-ntl@pobox.com>
 <20110403190324.GD15044@hallyn.com>
 <1301929228.31531.39.camel@tp-t61>
 <20110404151017.GA4857@hallyn.com>
 <1301931608.31531.49.camel@tp-t61>
 <20110404162753.GA3456@hallyn.com>
 <20110404104119.78189678.akpm@linux-foundation.org>
 <20110404185119.GB4782@peq.hallyn.com>
 <20110404124222.fd5eb85b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110404124222.fd5eb85b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> > As you know, we started with a minimal patchset, then grew it over time
> > to answer the "but how will you (xyz) without uglifying the kernel".
> > Would you recommend we go back to keeping a separate minimal patchset,
> > or that we develop on the current, pretty feature-full version?  I'm not
> > convinced believe there will be bandwidth to keep two trees and do both
> > justice.
> 
> The minimal patchset is too minimal for Oren's use and the maximal
> patchset seems to have run aground on general kernel sentiment.  So I

Sorry, when you say 'minimal patchset', are you referring to Nathan's tree?
Or a truly minimal patchset like what we originally started with?

thanks,
-serge
