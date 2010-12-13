Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab0LMTrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:47:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54170 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687Ab0LMTrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:47:42 -0500
Message-ID: <4D06783C.6040009@zytor.com>
Date: Mon, 13 Dec 2010 11:47:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Stanislaw Gruszka <sgruszka@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101203111623.GA2741@redhat.com> <AANLkTi=Xvbi5M_cNRL=wC+uwksG08SiCyWcqdmwB_5TU@mail.gmail.com> <20101203171147.GA2299@redhat.com> <20101203175401.GE28603@hmsreliant.think-freely.org> <20101207105053.GA2803@redhat.com> <4CFE89FE.1090901@kernel.org> <20101208141942.GA2335@redhat.com> <4D00823A.9050808@kernel.org> <20101209124117.GA6032@redhat.com> <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org>
In-Reply-To: <4D0663F0.2060103@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 10:20 AM, Yinghai Lu wrote:
> 
> it seems 32bit kdump need crashkernel much low than we expect...
> 
> Maybe we have to find_in_range_low() to make 32bit kdump happy.
> 

Not this garbage again... sigh.  Once again, I will want to know what
the actual constraint is... not just "oh, this seems to work on this one
system."

I realize that the kdump interfaces are probably beyond saving -- we
have had this discussion enough times -- but I'm not happy about it and
I will really want to know what the heck the real issue is.

Furthermore, such a function should NOT be private to x86 core; if it's
needed at all it should live in the memblock core.

	-hpa
