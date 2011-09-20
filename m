Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab1ITGCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 02:02:13 -0400
Received: from fsmail-out.f-secure.com ([193.110.108.171]:52462 "EHLO
	fsmail-out.f-secure.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab1ITGCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 02:02:12 -0400
Message-ID: <4E782C62.507@f-secure.com>
Date: Tue, 20 Sep 2011 09:02:10 +0300
From: Tarkan Erimer <tarkan.erimer@f-secure.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110907 Thunderbird/6.0.2
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] i915 crashes X Server Constantly on Linux-3.1-rc4 to .rc6
References: <4E770FF5.8030207@f-secure.com> <aefc95$1fgrb6@orsmga001.jf.intel.com> <4E773E65.5040809@f-secure.com> <aefc95$1fih8n@orsmga001.jf.intel.com>
In-Reply-To: <aefc95$1fih8n@orsmga001.jf.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.4.6813,1.0.211,0.0.0000
 definitions=2011-09-20_02:2011-09-20,2011-09-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 04:33 PM, Chris Wilson wrote:
> That looks remarkably consistent. Can you please do a quick
> addr2line -e /usr/lib64/xorg/modules/drivers/intel_drv.so 0x3e7ce 0x44d34
>
> Also do you know which particular site triggers the issue?
> -Chris

Hi again Chris,

Here is the output as you requested :

linux-ou2v:~ # addr2line -e /usr/lib64/xorg/modules/drivers/intel_drv.so 
0x3e7ce 0x44d34
??:0
??:0
linux-ou2v:~ #

At least, there is one particular website that always reproduces the 
issue and it's :

http://www.instru.fi/piilolinssit



-- 
Tarkan Erimer
IT Service Deployment / 3rd Level Support / Snr. Linux Engineer

