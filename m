Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab1KHWhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 17:37:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39073 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926Ab1KHWhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 17:37:51 -0500
Date: Tue, 8 Nov 2011 23:37:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel Drake <dsd@laptop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Geode LX boot fails after x86 microcode revision change
Message-ID: <20111108223744.GA1996@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel Drake <dsd@laptop.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Borislav Petkov <bp@amd64.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com>
 <20111108203116.GF25083@aftab>
 <4EB9A6BC.7050600@zytor.com>
 <F625F33982F5D847987879CC59FF132D6F5B@storexdag03.amd.com>
 <CAMLZHHTu-FNphvt5_L7fxqRpPukfs8nbS71x3GYo5GsPBo5cNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMLZHHTu-FNphvt5_L7fxqRpPukfs8nbS71x3GYo5GsPBo5cNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 04:17:21PM -0600, Daniel Drake wrote:
> On Tue, Nov 8, 2011 at 4:13 PM, Petkov, Borislav
> <Borislav.Petkov@amd.com> wrote:
> > This could definitely explain why it hangs, the rdmsr_safe call is
> >  in early_init_amd(), so it could really be too early for exception tables.
> 
> I think this is almost certainly the cause too. The symptoms of this
> issue are exactly the same as the early boot hang once discussed in a
> thread titled "Dynamic nop selection breaks boot on Geode LX" (which
> you wrote to as well) which was a problem of running code before
> having exception tables set up.

Oh yeah, that.

> I haven't yet run your tests except for "rdmsr 0x8b" which returns
> "pread: Input/output error" - let me know if you would still like
> results from the other tests.

Yep, just send me /proc/cpuinfo from a working kernel.

Thanks.

-- 
Regards/Gruss,
   Boris
