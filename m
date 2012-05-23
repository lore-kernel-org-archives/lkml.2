Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933956Ab2EWTWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:22:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43934 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933876Ab2EWTWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:22:32 -0400
Message-ID: <4FBD38EB.6040408@zytor.com>
Date: Wed, 23 May 2012 12:22:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
References: <20120521163727.GA13337@redhat.com> <alpine.LFD.2.02.1205211940030.3231@ionos> <20120521215127.GH17031@redhat.com> <alpine.LFD.2.02.1205220012020.3231@ionos> <20120521222449.GJ17031@redhat.com> <alpine.LFD.2.02.1205220044460.3231@ionos> <4FBB6E8B.8020200@redhat.com> <20120523144846.GA26974@gmail.com> <20120523151424.GA30542@redhat.com>
In-Reply-To: <20120523151424.GA30542@redhat.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 08:14 AM, Michael S. Tsirkin wrote:
> On Wed, May 23, 2012 at 04:48:46PM +0200, Ingo Molnar wrote:
>> there's just so many hours in the merge window, so you asked to be
>> flamed ...
> 
> I can handle flames just fine :) But I'll try to buffer x86 things up
> until the window closes next time.
> 

It's generally a good rule for anything for beyond the merge window
(i.e. for 3.6 in this case.)

It is *way* too easy to get down rathole confusions otherwise.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

