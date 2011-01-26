Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab1AZLo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:44:27 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55573 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab1AZLoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:44:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KoTlXhyWWUYYN5/hQHCzNkd3VGleACPRo2CDf3G5gb5DVZKYRF4QLLdDtAOZ2WcFOM
         16ZV86PdCnVoKhV7hGTWvH2hJzjY3KTpVG1VM7bWHCA0zjM9MLNZADkKW+bsaz3Za795
         KapNaQCAL/tD+TDeJqmPWEQ1C0aMybirxrfxY=
Date: Wed, 26 Jan 2011 13:44:15 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86-ML <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>,
        Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@suse.de>,
        Mark Lord <kernel@teksavvy.com>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk
	upon panic
Message-ID: <20110126114415.GB24527@laptop>
References: <20110125134748.GA10051@laptop> <20110125140948.GA26762@elte.hu> <20110125150834.GD27510@htj.dyndns.org> <4D3F095E.9000004@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3F095E.9000004@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 09:33:18AM -0800, H. Peter Anvin wrote:
> On 01/25/2011 07:08 AM, Tejun Heo wrote:
> 
> >> All in one, a very intriguing idea IMO, and the hardest bits
> >> (lowlevel x86 transition) is all implemented already.
> 
> Lowlevel x86 transition is not at all the hardest part.  It's
> detail-oriented but well defined (and, I might add, incompletely
> implemented -- 64 bits only, not using facilities we already have);
>

Making the transition code applicable to 32-bit CPUs will hopefully be
quite simple: it's mostly a subset of the posted parts.

Since I might use that transition code for a different purpose now, any
facilities not properly used beside the identity mappings?

thanks,

-- 
Darwish
http://darwish.07.googlepages.com
