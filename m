Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946413Ab2ESBBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 21:01:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9305 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965436Ab2ESBBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 21:01:08 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wom5GMh1gUkA:10 a=x7mfEr8YMI8A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=MtHueFpr6HgN3IXgc4wA:9 a=CjuIK1q_8ugA:10 a=U62fhAwekXMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Date: Fri, 18 May 2012 21:01:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/54] 3.0.32-stable review
Message-ID: <20120519010105.GB18264@home.goodmis.org>
References: <20120518212656.GA4992@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518212656.GA4992@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 02:26:56PM -0700, Greg KH wrote:
> This is the start of the stable review cycle for the 3.0.32 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun May 20 21:15:57 UTC 2012.
> Anything received after that time might be too late.

You really want people to work over the weekends don't you? ;-)

Well, I set up a box to run ktest randconfigs and some other checks.
Right now it's running on the 3.2.18-rc release. If I can sneak away
from the misses, I may be able to kick off tests against these releases
too. But I only have one box dedicated for this, so everything needs to
be processed serially.

-- Steve

> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.32-rc1.gz
> and the diffstat can be found below.
