Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab1IWTlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 15:41:53 -0400
Received: from mail-01.cse.ucsc.edu ([128.114.48.32]:36886 "EHLO
	mail-01.cse.ucsc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab1IWTlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 15:41:52 -0400
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Sep 2011 15:41:52 EDT
Message-ID: <4E7CDF4A.4070207@cs.ucsc.edu>
Date: Fri, 23 Sep 2011 12:34:34 -0700
From: Noah Watkins <jayhawk@cs.ucsc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Sage Weil <sage@newdream.net>
CC: Noah Watkins <noahwatkins@gmail.com>, ceph-devel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ceph: use kernel DNS resolver
References: <CAB2gnbVw2_FSWVVmUA1OobE1Ti9Q1w3AP_67=Vo4zwZtQ=gHYg@mail.gmail.com> <Pine.LNX.4.64.1109221426310.19558@cobra.newdream.net> <CAB2gnbVaS=x9hurY0P8x4Ltqh11foOpsMBy2MNt662T2X9+BLQ@mail.gmail.com> <Pine.LNX.4.64.1109231213580.31698@cobra.newdream.net>
In-Reply-To: <Pine.LNX.4.64.1109231213580.31698@cobra.newdream.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2011 12:15 PM, Sage Weil wrote:

> So I was actually thinking we could just #ifdef off of 
> CONFIG_DNS_RESOLVER, but I think your approach might be better because 
> you'll see it in the config process and turn it on, vs having to dig 
> through to wherever DNS_RESOLVER lives in kconfig.


Yeh, that was my thinking too. Also, if we just use DNS_RESOLVER then a
Ceph user would have no way of turning off the feature if another
required feature had a dependency on DNS_RESOLVER.

> Maybe it should default y though?


It definitely doesn't hurt anything. I'll send v3 with default y.

-Noah
