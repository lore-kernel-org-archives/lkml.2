Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab1KYMh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 07:37:28 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:37300 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab1KYMh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 07:37:27 -0500
Date: Fri, 25 Nov 2011 21:37:21 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Dave Jones <davej@redhat.com>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111125123720.GA31564@gamma.logic.tuwien.ac.at>
References: <20111122072730.GA32225@gamma.logic.tuwien.ac.at> <CANUX_P15En9bHVx4bhq6=XKPZnC2u+QyVJ+jnm4ns=39DrOBtg@mail.gmail.com> <2D0C7905-AEB2-4DE4-89B1-945D89F2B5D6@logic.at> <CANUX_P21PDdyo4u-x_1A0Lcqf-33yHgzUxddAoc3juGRNnrcDg@mail.gmail.com> <20111122124357.GA32440@gamma.logic.tuwien.ac.at> <CANUX_P0uyyuK4netV6srYCh9FsC4cpGzxobHE3T38n5RvvA0RQ@mail.gmail.com> <20111123015503.GC23203@gamma.logic.tuwien.ac.at> <CANUX_P1zDDzMy5yrFXSZAkMQ-87uu-fE1e-2sCEgHJi4dh5eiw@mail.gmail.com> <20111125122143.GA30404@gamma.logic.tuwien.ac.at> <CANUX_P1hFzSVPQzd6gq3tLY7hu+LX5suph6uHP+hq6+7rdAK1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUX_P1hFzSVPQzd6gq3tLY7hu+LX5suph6uHP+hq6+7rdAK1w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fr, 25 Nov 2011, Emmanuel Grumbach wrote:
> Well.. All this is really Layer 2 related, and even lower. It is a

Yeah, that was my impression too, but still, I wanted to mention it.

> I am already on week-end here and will look at it more carefully
> later. First impression is that things are messy here. I guess we are
> getting in a bad failure path that wasn't checked...

No problem, I can cope with it.

Generally after unloading nad reloading the module 1-2 times it gets
stable. Don't ask me why. No hurry

Have a nice weekend

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
WEEM (n.)
The tools with which a dentist can inflict the greatest
pain. Formerly, which tool this was dependent upon the imagination and
skill of the individual dentist, though now, with technological
advances, weems can be bought specially.
			--- Douglas Adams, The Meaning of Liff
