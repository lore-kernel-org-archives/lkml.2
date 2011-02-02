Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab1BBLNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 06:13:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39933 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab1BBLNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 06:13:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=leXFgxiMm5ZNApgN0lzBdX7P8LQuatVLzAOAFiidx+jHWMLEHZJN4j+jB0BiwBf2Z3
         DUv42JTJ7KW8gC23fOSl+hRXJTqerfcLU5zGHkFyQ6scvZtbdZL9zoeVcE8SdqWn/jIc
         cZT0KgiqRD3tDcT/FprChGbGghOdBUKfTrxGQ=
Date: Wed, 2 Feb 2011 13:13:38 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86-ML <x86@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>,
        Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@suse.de>,
        Mark Lord <kernel@teksavvy.com>, Jeff Garzik <jgarzik@pobox.com>,
        Haren Myneni <hbabu@us.ibm.com>, KEXEC-ML <kexec@lists.infradead.org>,
        FBDEV-ML <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk
	upon panic
Message-ID: <20110202111338.GA15729@laptop>
References: <20110125134748.GA10051@laptop> <AANLkTinU0KYiCd4p=z+=ojbkeEoT2G+CAYvdRU02KJEn@mail.gmail.com> <20110126124954.GC24527@laptop> <20110127021338.GA20334@redhat.com> <4D40F81E.1030009@zytor.com> <20110127052639.GA16289@laptop> <m1sjweyeax.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m1sjweyeax.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Quick note: the Internet has just returned back here after a full
5-day shutdown by the “authorities”. I will hopefully return back
home on Saturday to continue working on this.

thanks,
