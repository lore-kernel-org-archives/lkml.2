Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1K0Koi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 05:44:38 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37521 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1K0Kog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 05:44:36 -0500
MIME-Version: 1.0
In-Reply-To: <1322387175.4044.16.camel@jlt3.sipsolutions.net>
References: <20111122072730.GA32225@gamma.logic.tuwien.ac.at>
	<CANUX_P15En9bHVx4bhq6=XKPZnC2u+QyVJ+jnm4ns=39DrOBtg@mail.gmail.com>
	<2D0C7905-AEB2-4DE4-89B1-945D89F2B5D6@logic.at>
	<CANUX_P21PDdyo4u-x_1A0Lcqf-33yHgzUxddAoc3juGRNnrcDg@mail.gmail.com>
	<20111122124357.GA32440@gamma.logic.tuwien.ac.at>
	<CANUX_P0uyyuK4netV6srYCh9FsC4cpGzxobHE3T38n5RvvA0RQ@mail.gmail.com>
	<20111123015503.GC23203@gamma.logic.tuwien.ac.at>
	<CANUX_P1zDDzMy5yrFXSZAkMQ-87uu-fE1e-2sCEgHJi4dh5eiw@mail.gmail.com>
	<20111125122143.GA30404@gamma.logic.tuwien.ac.at>
	<CANUX_P1hFzSVPQzd6gq3tLY7hu+LX5suph6uHP+hq6+7rdAK1w@mail.gmail.com>
	<20111125123720.GA31564@gamma.logic.tuwien.ac.at>
	<CANUX_P2mGQX9H-f7OFusjUrv8ey56JNzFVEdKJkAejsg9zVNkQ@mail.gmail.com>
	<CANUX_P1aAz-4TpgSzQ2G=RkJOxXCAVQBja3GNsj_HpMNmqxeUw@mail.gmail.com>
	<1322387175.4044.16.camel@jlt3.sipsolutions.net>
Date: Sun, 27 Nov 2011 12:44:35 +0200
Message-ID: <CANUX_P3uoNOj3j-REvYCZP382cHfq+DpBRi7fnzFfMG_dyHtTQ@mail.gmail.com>
Subject: Re: iwlagn is getting very shaky
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Norbert Preining <preining@logic.at>,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 11:46, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2011-11-27 at 11:43 +0200, Emmanuel Grumbach wrote:
>> Hi again
>>
>> Can you please try the attached patch ?
>> I would like to know if it helps.
>
> As in the patch that Nikolay sent to the list earlier today, this should
> also check STOPPING since WANT_STOP may get cleared as soon as it is
> processed.
>

Thanks.
Norbert, could you please test Nikolay's patch instead of mine ?
