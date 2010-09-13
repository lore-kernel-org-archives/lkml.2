Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab0IMKMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:12:15 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40749 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab0IMKMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 06:12:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D6DkZaLWQxDsPDYYbu7ZLaBPGugwTizKhgqJ0VJ/oubiiIVwNFJP1FrRO/MTb7vGHZ
         5avjcEc3Yfjj1G89wA0NUsWBm64imG1wTXPTx5mMcatQD3+cEcPFEFjAD7m79NNOHXrL
         t1pcIJhxztAMekfBRbdajDJTOMoU8aA8AnCDo=
Date: Mon, 13 Sep 2010 14:12:10 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        mingo@elte.hu, robert.richter@amd.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, ying.huang@intel.com,
        ming.m.lin@intel.com, yinghai@kernel.org, andi@firstfloor.org
Subject: Re: [PATCH 0/3 v2] nmi perf fixes
Message-ID: <20100913101210.GG5728@lenovo>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com> <1284118900.402.35.camel@laptop> <1284125693.402.58.camel@laptop> <1284126770.402.60.camel@laptop> <20100913085515.GC5728@lenovo> <AANLkTi=AceFvNNQmsDYE0MTbOX804P1+mewcr=bAFzXi@mail.gmail.com> <20100913100743.GF5728@lenovo> <AANLkTimLRPe2T7pCo=33MWMjDg1qhAPdSmUA80kYAGrq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimLRPe2T7pCo=33MWMjDg1qhAPdSmUA80kYAGrq@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 12:10:00PM +0200, Stephane Eranian wrote:
...
> > Hi Stephane, the hackbench is Ingo's one? I've been using
> > http://people.redhat.com/mingo/cfs-scheduler/tools/hackbench.c
> >
> No, it's one I found via google search:
> 
> http://devresources.linuxfoundation.org/craiger/hackbench/
> 

ok, tried it as well -- no NMI issue.

	-- Cyrill
