Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab1KIM1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:27:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab1KIM1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:27:04 -0500
Message-ID: <4EBA717A.8010300@redhat.com>
Date: Wed, 09 Nov 2011 13:26:34 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Theodore Tso <tytso@mit.edu>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git	repository,
 tools/perf/ and tools/kvm/
References: <4EB85969.2010108@codemonkey.ws> <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu> <20111108093225.GB32533@elte.hu> <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu> <20111108125609.GA14272@ghostprotocols.net> <4EB9315A.10806@redhat.com> <20111108143228.GC14272@ghostprotocols.net> <4EB94D08.3010207@redhat.com> <20111109085120.GD11473@elte.hu> <4EBA5881.7080409@redhat.com> <20111109115502.GA18207@ghostprotocols.net>
In-Reply-To: <20111109115502.GA18207@ghostprotocols.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

>>> Plus allowing full .perfconfig configurability of all the relevant 
>>> colors, for those with special taste.
>>
>> Sure.  Maybe also allow multiple color sections and pick them by $TERM
>> or --colors switch, i.e. [colors "xterm"].
> 
> Its fully configurable as of now, what we need is a set of .perfconfigs
> that show how people think its better, we try it, set it as the default,
> leave the others in tools/perf/Documentation/perfconfig/color.examples.

Yep, a set of examples works too.

The colors are not fully configurable yet though.  First, when switching
all five colorsets to "default, default" there are still things which
are colored (top bar, bottom bar, keys help display).  Second there is
no way to set terminal attributes (i.e. "top = bold" or "selected =
reverse").

cheers,
  Gerd
