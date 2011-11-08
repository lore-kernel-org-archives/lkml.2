Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab1KHWTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 17:19:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55730 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492Ab1KHWTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 17:19:48 -0500
Message-ID: <4EB9AAF1.4040103@zytor.com>
Date: Tue, 08 Nov 2011 14:19:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "Petkov, Borislav" <Borislav.Petkov@amd.com>
CC: Borislav Petkov <bp@amd64.org>, Daniel Drake <dsd@laptop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Geode LX boot fails after x86 microcode revision change
References: <CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com> <20111108203116.GF25083@aftab>,<4EB9A6BC.7050600@zytor.com> <F625F33982F5D847987879CC59FF132D6F5B@storexdag03.amd.com>
In-Reply-To: <F625F33982F5D847987879CC59FF132D6F5B@storexdag03.amd.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2011 02:13 PM, Petkov, Borislav wrote:
> 
> This could definitely explain why it hangs, the rdmsr_safe call is
>  in early_init_amd(), so it could really be too early for exception tables.
> 

Yes, it is.

> If so, then a family check is unavoidable.

Either that, or make changes so that we can handle exceptions earlier.
That would be useful for other reasons.

	-hpa
