Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab2C1AQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:16:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21403 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab2C1AQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:16:24 -0400
X-Authority-Analysis: v=2.0 cv=P4S4d18u c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5BTByhnut4wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=b8VgSBC0AAAA:8 a=zkbMhFB6tdBLrs_B_HwA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332893782.23924.140.camel@gandalf.stny.rr.com>
Subject: Re: [BUG] Warning at radeon_object.c:236 with latest Linus kernel
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        Michel =?UTF-8?Q?D=C3=83=E2=82=ACnzer?= <michel.daenzer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Date: Tue, 27 Mar 2012 20:16:22 -0400
In-Reply-To: <1332893642.23924.139.camel@gandalf.stny.rr.com>
References: <1332893642.23924.139.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 20:14 -0400, Steven Rostedt wrote:
> You can get the full dmesg here:
> 
> http://rostedt.homelinux.com/private/dmesg-bxf-20120327


And the config is here:

http://rostedt.homelinux.com/private/config-bxf-20120327

-- Steve


