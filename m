Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab1KVSy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 13:54:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60058 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251Ab1KVSyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 13:54:25 -0500
Message-ID: <4ECBEFCB.6010905@zytor.com>
Date: Tue, 22 Nov 2011 10:54:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Daniel Drake <dsd@laptop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Geode LX boot fails after x86 microcode revision change
References: <CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com> <20111108203116.GF25083@aftab> <4EB9A6BC.7050600@zytor.com> <F625F33982F5D847987879CC59FF132D6F5B@storexdag03.amd.com> <4EB9AAF1.4040103@zytor.com> <20111122130048.GB11020@aftab>
In-Reply-To: <20111122130048.GB11020@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 05:00 AM, Borislav Petkov wrote:
> 
> Also, we might need the patches which sort extable at build time too,
> which are floating around lkml currently.
> 
> Hmm...
> 

Yes, with the extable set up at build time there isn't really any strong
reason why we couldn't take exceptions very early.

I am supposed to dredge up the perfect hash code I already have for this
(I'm away from work this and next week to deal with personal stuff, so
it might be a bit slow.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

