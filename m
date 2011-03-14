Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab1CNHD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 03:03:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab1CNHD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 03:03:27 -0400
Subject: RE: PROBLEM: brcm80211 unable to survive suspend/resume cycle
From: Jon Masters <jcm@redhat.com>
To: Arend Van Spriel <arend@broadcom.com>
Cc: devel <devel@linuxdriverproject.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1295459500.9781.127.camel@constitution.bos.jonmasters.org>
References: <1289272437.3916.440.camel@constitution.bos.jonmasters.org>
	 <7A94256FD72B884D9E7C55586C3CBCEE13840C62AA@SJEXCHCCR01.corp.ad.broadcom.com>
	 <1289880279.3916.889.camel@constitution.bos.jonmasters.org>
	 <1293028287.6319.171.camel@constitution.bos.jonmasters.org>
	 ,<1295457365.9781.108.camel@constitution.bos.jonmasters.org>
	 <400C43189542CE41BC0A5B252FC90136952F059547@SJEXCHCCR02.corp.ad.broadcom.com>
	 <1295459500.9781.127.camel@constitution.bos.jonmasters.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat, Inc.
Date: Mon, 14 Mar 2011 03:09:18 -0400
Message-ID: <1300086558.22748.38.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 12:51 -0500, Jon Masters wrote:
> On Wed, 2011-01-19 at 09:43 -0800, Arend Van Spriel wrote:
> 
> > I tried to give you a heads up. I submitted the patch last friday to the
> > staging-2.6 repository. Not sure whether it has propagated to the 2.6.3[78]
> > kernels yet.
> 
> Awesome. Sometime soon, I guess it will land and I'll test it for you :)

Latest upstream staging is working across suspend quite nicely. I did,
however, separately ping David Woodhouse to let him know that there is
some discrepancy between the firmware names you are looking for in the
brcm80211 driver and the firmware names in the linux-firmware rawhide
(Fedora) package such that one has to manually symlink stuff - can you
confirm that the current naming you're looking for is going to remain
consistent in the future if symlinks are fixed in linux-firmware?

Jon.


