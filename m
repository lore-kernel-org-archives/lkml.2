Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab1LMFXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 00:23:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55743 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1LMFXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 00:23:15 -0500
Message-ID: <4EE6E140.904@gmail.com>
Date: Mon, 12 Dec 2011 22:23:12 -0700
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: skeggsb@gmail.com
CC: Dave Airlie <airlied@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: DRM nouveau crash with 3.2.0-rc5
References: <4EE2E9BB.8060801@gmail.com>			<CAPM=9tzVxGbsE4+EgTd0apvGBCUcvtnjSH-ydbr-MOVSTf1QaQ@mail.gmail.com>		 <CACAvsv6g+qz+-ja+4Qfinz04rr0EAyxwxQpFyfcE1fAtqQyuEA@mail.gmail.com>		 <4EE42ADA.5000406@gmail.com> <1323590203.31951.2.camel@nisroch>	 <4EE564CF.8090203@gmail.com> <1323753537.10514.0.camel@nisroch>
In-Reply-To: <1323753537.10514.0.camel@nisroch>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 10:18 PM, Ben Skeggs wrote:
> Are you able to bisect this back to a commit?  I've attempted on a few
> different cards to cause this and I'm not seeing it.
> 
> It might take a while to bisect given that it's hard for you to
> reproduce, but, it'd be *very* helpful.

Oof.  Assuming that the bisection points are generally usable, I'll give
it a try and see how it goes.  Don't expect any immediate answers:)

Berck
