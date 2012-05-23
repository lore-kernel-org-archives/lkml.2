Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979Ab2EWPOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:14:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885Ab2EWPOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:14:32 -0400
Date: Wed, 23 May 2012 18:14:25 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
Message-ID: <20120523151424.GA30542@redhat.com>
References: <20120521163727.GA13337@redhat.com>
 <alpine.LFD.2.02.1205211940030.3231@ionos>
 <20120521215127.GH17031@redhat.com>
 <alpine.LFD.2.02.1205220012020.3231@ionos>
 <20120521222449.GJ17031@redhat.com>
 <alpine.LFD.2.02.1205220044460.3231@ionos>
 <4FBB6E8B.8020200@redhat.com>
 <20120523144846.GA26974@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523144846.GA26974@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 04:48:46PM +0200, Ingo Molnar wrote:
> there's just so many hours in the merge window, so you asked to be
> flamed ...

I can handle flames just fine :) But I'll try to buffer x86 things up
until the window closes next time.

-- 
MST
