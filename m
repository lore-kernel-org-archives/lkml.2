Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab1ANWP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 17:15:59 -0500
Received: from kroah.org ([198.145.64.141]:52523 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab1ANWP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 17:15:58 -0500
Date: Fri, 14 Jan 2011 14:16:16 -0800
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Christoph Lameter <cl@linux.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] x86: set percpu cpu0 lpj to default
Message-ID: <20110114221616.GA17959@kroah.com>
References: <4D2F7AE9.2000809@kernel.org>
 <20110113224450.GA14918@kroah.com>
 <alpine.LFD.2.00.1101132349590.2678@localhost6.localdomain6>
 <4D2F84FC.7000804@kernel.org>
 <20110113234852.GB17904@kroah.com>
 <4D2F9948.8000804@kernel.org>
 <20110114004428.GA26847@kroah.com>
 <4D2FA305.2030808@kernel.org>
 <alpine.DEB.2.00.1101140846560.2423@router.home>
 <4D30BE98.7060809@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D30BE98.7060809@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 01:22:32PM -0800, Yinghai Lu wrote:
> 
> We need to use udelay() in early stage.

I still don't agree with this.

Again, _please_ post your real patches that require this, after
explaining exactly _why_ this is needed at all, and what real problem it
is solving.

You seem to be totally ignoring this request I've made numerous times,
which isn't appreciated at all.  So I'm guessing that we should also
ignore your patches as well?

thanks,

greg k-h
