Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1GNCsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 22:48:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60248 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1GNCsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 22:48:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E1E58E8.6040200@jp.fujitsu.com>
Date: Thu, 14 Jul 2011 11:48:08 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: david@fromorbit.com
CC: chris@chris-wilson.co.uk, keithp@keithp.com, linux-kernel@vger.kernel.org,
        airlied@linux.ie, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] i915: slab shrinker have to return -1 if it cant shrink
 any objects
References: <4E0444CA.3080407@jp.fujitsu.com> <yuny60kt1nx.fsf@aiko.keithp.com> <1309424153_44559@CP5-2952> <4E1C15B2.9020800@jp.fujitsu.com> <d08817$ot4e1@azsmga001.ch.intel.com> <4E1CE48C.2070402@jp.fujitsu.com> <d08817$pb86v@azsmga001.ch.intel.com> <4E1D550A.80301@jp.fujitsu.com> <20110713104236.GS23038@dastard>
In-Reply-To: <20110713104236.GS23038@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If you are thinking the shrinker protocol is too complicated, doc update
>> patch is really welcome.
> 
> Slab shrinkers have a nasty, crappy interface and the shrink_slab()
> code is full of bugs.  Rather that telling people to "update the
> documentation" because it's too complex, how about we fix the
> interface and the bugs?

If you can take your time for that, I don't hesitate to help you. ;)


