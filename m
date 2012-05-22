Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab2EVKqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:46:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab2EVKqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:46:47 -0400
Message-ID: <4FBB6E8B.8020200@redhat.com>
Date: Tue, 22 May 2012 13:46:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
References: <20120521163727.GA13337@redhat.com> <alpine.LFD.2.02.1205211940030.3231@ionos> <20120521215127.GH17031@redhat.com> <alpine.LFD.2.02.1205220012020.3231@ionos> <20120521222449.GJ17031@redhat.com> <alpine.LFD.2.02.1205220044460.3231@ionos>
In-Reply-To: <alpine.LFD.2.02.1205220044460.3231@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 02:01 AM, Thomas Gleixner wrote:
> > 
> > Others are not my fault :)
> > 
> > Seriously, if Avi/Marcelo want to rewrite the ISR emulation
>
> Interesting POV, really.
>
> Did you ever notice that the kernel is a collaborative effort and not
> controlled by "Avi/Marcelo"?
>
> Did you ever notice that arch/x86/kvm is part of arch/x86? 

This is silly.  Most of the time the kernel is advanced by incremental
patches.  Sometimes it is advanced by minor or major refactoring.  It is
never advanced by personal attacks on contributors.

-- 
error compiling committee.c: too many arguments to function

