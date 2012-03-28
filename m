Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab2C1A26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:28:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11221 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390Ab2C1A25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:28:57 -0400
X-Authority-Analysis: v=2.0 cv=Z8Fu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5BTByhnut4wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=e5mUnYsNAAAA:8 a=meVymXHHAAAA:8 a=6GX3V7WQ5h6dkosQX6wA:9 a=PUjeQqilurYA:10 a=vbfkGdecwzEA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332894535.23924.142.camel@gandalf.stny.rr.com>
Subject: RE: [BUG] Warning at radeon_object.c:236 with latest Linus kernel
From: Steven Rostedt <rostedt@goodmis.org>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        "Daenzer, Michel" <Michel.Daenzer@amd.com>
Date: Tue, 27 Mar 2012 20:28:55 -0400
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D013853C30@sausexdag01.amd.com>
References: <1332893642.23924.139.camel@gandalf.stny.rr.com>
	 <1332893782.23924.140.camel@gandalf.stny.rr.com>
	 <A3397C8B8B789E45844E7EC5DEAD89D013853C30@sausexdag01.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 00:17 +0000, Deucher, Alexander wrote:

> Can you try this patch:
> http://lists.freedesktop.org/archives/dri-devel/2012-March/020606.html

Seems to have fixed the issue. Also, is there a way to get a raw version
of a patch from this web site? I don't like manually cut and pasting
patches out of the browser.

Tested-by: Steven Rostedt <rostedt@goodmis.org>

Thanks!

-- Steve


