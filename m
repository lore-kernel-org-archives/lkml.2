Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1JUQEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 12:04:09 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64917 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab1JUQEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 12:04:07 -0400
MIME-Version: 1.0
In-Reply-To: <20111020105950.fd04f58f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111020013305.GD21703@tiehlicka.suse.cz>
	<20111020105950.fd04f58f.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 21 Oct 2011 21:34:06 +0530
Message-ID: <CAKTCnz=iZp37sBfY++HUU0oscskFF_UWYeFYtAujtQh4_B=vHQ@mail.gmail.com>
Subject: Re: [RFD] Isolated memory cgroups again
From: Balbir Singh <bsingharora@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        Kir Kolyshkin <kir@parallels.com>,
        Pavel Emelianov <xemul@parallels.com>, GregThelen <gthelen@google.com>,
        "pjt@google.com" <pjt@google.com>, Tim Hockin <thockin@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 7:29 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 19 Oct 2011 18:33:09 -0700
> Michal Hocko <mhocko@suse.cz> wrote:
>
>> Hi all,
>> this is a request for discussion (I hope we can touch this during memcg
>> meeting during the upcoming KS). I have brought this up earlier this
>> year before LSF (http://thread.gmane.org/gmane.linux.kernel.mm/60464).
>> The patch got much smaller since then due to excellent Johannes' memcg
>> naturalization work (http://thread.gmane.org/gmane.linux.kernel.mm/68724)
>> which this is based on.
>

Hi, Michal

I'd like to understand, what the isolation is for?

1. Is it an alternative to memory guarantees?
2. How is this different from doing cpusets (fake NUMA) and isolating them?

Just trying to catch up,
Balbir
