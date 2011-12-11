Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab1LKEAb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 23:00:31 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54686 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab1LKEA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 23:00:29 -0500
Message-ID: <4EE42ADA.5000406@gmail.com>
Date: Sat, 10 Dec 2011 21:00:26 -0700
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Ben Skeggs <skeggsb@gmail.com>
CC: Dave Airlie <airlied@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: DRM nouveau crash with 3.2.0-rc5
References: <4EE2E9BB.8060801@gmail.com>	<CAPM=9tzVxGbsE4+EgTd0apvGBCUcvtnjSH-ydbr-MOVSTf1QaQ@mail.gmail.com> <CACAvsv6g+qz+-ja+4Qfinz04rr0EAyxwxQpFyfcE1fAtqQyuEA@mail.gmail.com>
In-Reply-To: <CACAvsv6g+qz+-ja+4Qfinz04rr0EAyxwxQpFyfcE1fAtqQyuEA@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2011 08:54 PM, Ben Skeggs wrote:
> Is this reproducible in any way, or a once off occurance?
> 
> It's hard to know if it's a regression or some random bug that's existed
> forever.

It only happened once, but nothing like it has ever happened with 3.1,
and after it happened, I've reverted back to using 3.1.  And it
shouldn't happen.  I suppose I can see if I can make it happen again...
