Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab2DFQO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 12:14:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44130 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab2DFQO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 12:14:27 -0400
Message-ID: <4F7F1659.5090305@zytor.com>
Date: Fri, 06 Apr 2012 09:14:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by> <4F78D0BA.9040709@zytor.com> <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com>
In-Reply-To: <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2012 02:54 AM, Alexey Dobriyan wrote:
> 
> I agree, this particular changelog may be somewhat out of line.
> 
> But I find it little hypocritical that kernel developers add CONFIG_PROC_FS,
> fix compilation problems associated with it, do not mount proc by default,
> do not mark it unmountable somehow and
> then say procless setups aren't worth it.
> 

Aren't worth *optimizing for*.  But yes, CONFIG_PROC_FS is pretty much a
historic relic at this point, and probably should just be dropped.

> Without proc knowledge about fdtable is gathered linearly and still unreliable.
> With nextfd(2), even procful environments could lose several failure branches.

What?  Please explain how on Earth this would "lose several failure
branches."

New system calls are not something that should be added lightly...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

