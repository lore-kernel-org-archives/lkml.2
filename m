Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab2EROrC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:47:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32500 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab2EROq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:46:59 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wom5GMh1gUkA:10 a=PpG1Yf0aK_AA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=ITMrOGM4ltA3Vy2fEaIA:9 a=CjuIK1q_8ugA:10 a=U62fhAwekXMA:10 a=LI9Vle30uBYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Date: Fri, 18 May 2012 10:46:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/53] 3.2.18-stable review
Message-ID: <20120518144657.GA18264@home.goodmis.org>
References: <20120518023254.339945758@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 03:32:54AM +0100, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.18 release.
> There are 53 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun May 20 13:00:00 UTC 2012.
> Anything received after that time might be too late.
> 
> The whole patch series should soon be available in one patch at:
> 	kernel.org/pub/linux/kernel/v3.x/stable-review/patch-3.2.18-rc1.gz
> and the diffstat can be found below.

$ wget  kernel.org/pub/linux/kernel/v3.x/stable-review/patch-3.2.18-rc1.gz
--2012-05-18 10:44:23--  http://kernel.org/pub/linux/kernel/v3.x/stable-review/patch-3.2.18-rc1.gz
Resolving kernel.org (kernel.org)... 149.20.4.69
Connecting to kernel.org (kernel.org)|149.20.4.69|:80... connected.
HTTP request sent, awaiting response... 404 Not Found
2012-05-18 10:44:23 ERROR 404: Not Found.

How much is "soon"? Did you push it to the repo yet and I'm just waiting
on the mirroring? Or do you still need to push it yourself?

-- Steve

