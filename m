Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab0KVPkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 10:40:11 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48556 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab0KVPkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 10:40:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=OYV4kVMAl7cc4SEiMvbFPhP4rgbg6R0XcU6DFD1XKpuLbbs405RqYxuwpXPwRIb8wr
         dc5Xvwn7JMKl/oXjllJ9kOOqwQh3f42ZHg0LkNUXbQ+Ik4pmJNAxDn6RPjnyt3LaXJMB
         hYBy5mV2P4mZpBOoWvm/i4YVOejBm0cjXyY24=
Date: Mon, 22 Nov 2010 23:43:17 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Haicheng Li <haicheng.li@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org
Subject: Re: [patch 1/2] x86: add numa=possible command line option
Message-ID: <20101122154317.GC4137@hack>
References: <alpine.DEB.2.00.1011171304060.10254@chino.kir.corp.google.com> <20101118041407.GA2408@shaohui> <20101118062715.GD17539@linux-sh.org> <20101118052750.GD2408@shaohui> <alpine.DEB.2.00.1011181321470.26680@chino.kir.corp.google.com> <20101119003225.GB3327@shaohui> <alpine.DEB.2.00.1011201645230.10618@chino.kir.corp.google.com> <alpine.DEB.2.00.1011201826140.12889@chino.kir.corp.google.com> <20101121142615.GI9099@hack> <alpine.DEB.2.00.1011211343350.26304@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.1011211343350.26304@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 01:46:07PM -0800, David Rientjes wrote:
>On Sun, 21 Nov 2010, Américo Wang wrote:
>> Also, numa=possible= is not as clear as numa=max=, for me at least.
>> 
>
>I like name, but it requires that you know how many nodes that system 
>already has.  In other words, numa=possible=4 allows you to specify that 4 
>additional nodes will be possible, but initially offline, for this or 
>other purposes.  numa=max=4 would be no-op if the system actually had 4 
>nodes.
>
>I chose numa=possible over numa=additional because it is more clearly tied 
>to node_possible_map, which is the only thing it modifies.

Okay, I thought "possible" means "max", but "possible" means "addtional" here.
It's clear for me now.

Thanks!

