Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab1KHW7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 17:59:09 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47227 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab1KHW7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 17:59:06 -0500
MIME-Version: 1.0
In-Reply-To: <20111108223744.GA1996@x1.osrc.amd.com>
References: <CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com>
	<20111108203116.GF25083@aftab>
	<4EB9A6BC.7050600@zytor.com>
	<F625F33982F5D847987879CC59FF132D6F5B@storexdag03.amd.com>
	<CAMLZHHTu-FNphvt5_L7fxqRpPukfs8nbS71x3GYo5GsPBo5cNw@mail.gmail.com>
	<20111108223744.GA1996@x1.osrc.amd.com>
Date: Tue, 8 Nov 2011 16:59:05 -0600
X-Google-Sender-Auth: 4a1-v4CIJ2PR6HlX8lwBtctyj3g
Message-ID: <CAMLZHHRc+yNr=6SB7Z1t_hyL+e8a0T-BokyQ+wVUPw-vhd3rQA@mail.gmail.com>
Subject: Re: Geode LX boot fails after x86 microcode revision change
From: Daniel Drake <dsd@laptop.org>
To: Borislav Petkov <bp@alien8.de>, Daniel Drake <dsd@laptop.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 4:37 PM, Borislav Petkov <bp@alien8.de> wrote:
> Yep, just send me /proc/cpuinfo from a working kernel.

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 5
model		: 10
model name	: Geode(TM) Integrated Processor by AMD PCS
stepping	: 2
cpu MHz		: 430.927
cache size	: 128 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu de pse tsc msr cx8 sep pge cmov clflush mmx mmxext 3dnowext 3dnow
bogomips	: 861.85
clflush size	: 32
cache_alignment	: 32
address sizes	: 32 bits physical, 32 bits virtual
power management:

Thanks,
Daniel
