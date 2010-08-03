Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab0HCQBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 12:01:12 -0400
Received: from mx1.sophos.com ([195.166.81.52]:56017 "EHLO mx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341Ab0HCQBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 12:01:10 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Borislav Petkov <bp@amd64.org>
Subject: Re: 2.6.35 hangs on early boot in KVM
Date: Tue, 3 Aug 2010 17:01:05 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
CC: Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>
References: <201008031028.57263.tvrtko.ursulin@sophos.com> <201008031631.03111.tvrtko.ursulin@sophos.com> <20100803154901.GF28136@aftab>
In-Reply-To: <20100803154901.GF28136@aftab>
MIME-Version: 1.0
Message-ID: <201008031701.06278.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 03/08/2010 17:01:06,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 03/08/2010 17:01:06,
	Serialize complete at 03/08/2010 17:01:06
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 Aug 2010 16:49:01 Borislav Petkov wrote:
> From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
> Date: Tue, Aug 03, 2010 at 11:31:02AM -0400
>
> > > One interesting waning spotted:
> > >
> > > include/config/auto.conf:555:warning: symbol value '-fcall-saved-ecx
> > > -fcall- saved-edx' invalid for ARCH_HWEIGHT_CFLAGS
> >
> > Copying Peter and Borislav, guys please look at the above warning. I am
> > bisecting a non-bootable 2.6.35 under KVM and while I am not there yet,
> > it is close to the hweight commit
> > (cb41838bbc4403f7270a94b93a9a0d9fc9c2e7ea) and I spotted this warning.
>
> That's because you're at a bisection point before the hweight patch but
> your .config already contains the ARCH_HWEIGHT_CFLAGS variable because
> of the previous bisection point which contained the hweight patch.
>
> I think this can be safely ignored.

Yep, bisect pointed to another commit so I continued another part of this
thread. Thanks for the explanation!

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
