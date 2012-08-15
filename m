Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab2HOUcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:32:53 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37792 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393Ab2HOUcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 16:32:46 -0400
Message-ID: <502C07B4.6050104@gmail.com>
Date: Wed, 15 Aug 2012 22:33:56 +0200
From: =?ISO-8859-1?Q?Nicolas_de_Peslo=FCan?= 
	<nicolas.2p.debian@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Jiri Pirko <jiri@resnulli.us>
CC: Ben Hutchings <bhutchings@solarflare.com>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, faisal.latif@intel.com,
        roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        fubar@us.ibm.com, andy@greyhouse.net, divy@chelsio.com,
        jitendra.kalsaria@qlogic.com, sony.chacko@qlogic.com,
        linux-driver@qlogic.com, kaber@trash.net, ursula.braun@de.ibm.com,
        blaschka@linux.vnet.ibm.com, linux390@de.ibm.com,
        shemminger@vyatta.com, therbert@google.com, xiyou.wangcong@gmail.com,
        joe@perches.com, gregory.v.rose@intel.com, john.r.fastabend@intel.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, bridge@lists.linux-foundation.org,
        fbl@redhat.com
Subject: Re: [patch net-next 01/16] net: introduce upper device lists
References: <1344871635-1052-1-git-send-email-jiri@resnulli.us> <1344871635-1052-2-git-send-email-jiri@resnulli.us> <1344877451.2733.26.camel@bwh-desktop.uk.solarflarecom.com> <20120813173110.GA1808@minipsycho.orion>
In-Reply-To: <20120813173110.GA1808@minipsycho.orion>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 13/08/2012 19:31, Jiri Pirko a écrit :
> Mon, Aug 13, 2012 at 07:04:11PM CEST, bhutchings@solarflare.com wrote:

>>> +struct netdev_upper {
>>> +	struct net_device *dev;
>>> +	bool unique;
>>
>> This needs a better name.  It doesn't really have anything to do with
>> uniqueness and doesn't ensure exclusivity.  I think that it would be
>> fine to keep the 'master' term.
>
> Hmm. I admit that "unique" I do not like too much as well. But "master"
> I like even less.
>
> This flag should ensure exclusivity. Only one upper device with this
> flag can be present at a time.

Well, can't we simply call it "upper_device"?

And as we only have a single field, this is exclusive by design.

	Nicolas.
