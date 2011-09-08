Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab1IHDve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 23:51:34 -0400
Received: from mta21.charter.net ([216.33.127.81]:50249 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab1IHDvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 23:51:32 -0400
X-Authority-Analysis: v=1.1 cv=qtFpkpLoq1h6Rzh6To4jlydEWOxnTDhhQmDAOJLAbB0=
 c=1 sm=1 a=B2KfuYyhElYA:10 a=gbogK0oHmqgA:10 a=8nJEP1OIZ-IA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=20KFwNOVAAAA:8 a=xNjWJ0b5AAAA:8
 a=NEAV23lmAAAA:8 a=bktQ1ygIT-X8XGpNgKgA:9 a=wPNLvfGTeEIA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4E683BBE.3060105@cuw.edu>
Date: Wed, 07 Sep 2011 22:51:26 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iwlegacy: change IWL_WARN to IWL_DEBUG_HT in iwl4965_tx_agg_start
References: <1314537977-20097-1-git-send-email-Gregory.Dietsche@cuw.edu> <20110829122013.GA3597@redhat.com> <4E5B9533.6000109@cuw.edu> <20110829140032.GA1573@redhat.com> <20110906150131.GA7322@redhat.com>
In-Reply-To: <20110906150131.GA7322@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislaw,
On 09/06/2011 10:01 AM, Stanislaw Gruszka wrote:
> I put patches here:
> http://people.redhat.com/sgruszka/iwlegacy_cleanup.tar.bz2
>
> They are on top of wireless-testing tree.
>    
<snip>
> Series include your 2 patches. You can test this cleanup and
> apply your new changes on top. I'll not do any further cleanup
> for some time now, perhaps continue when I got public git tree.
>
>    
Thanks! I've re-worked my patches and you can find them here:
http://www.gregd.org/stuff/linux/iwlegacy_cleanup_greg.tar.bz2

I also decided to play with github a little bit: 
git://github.com/dietsche/linux.git and pushed two branches:
   1) wireless-next-iwlegacy-stanislaw - your patch set
   2) wireless-next-iwlegacy-stanislaw-greg - a branch that has my 
additional patches.
`git format-patch 
wireless-next-iwlegacy-stanislaw..wireless-next-iwlegacy-stanislaw-greg` 
will generate the patches that are in the link i posted above.

The first two patches in my series are the ones that I think folks 
should take a closer look at. The rest are pretty safe.

I'm running both patch sets right now on my laptop. So far it is running 
perfectly.

Greg

