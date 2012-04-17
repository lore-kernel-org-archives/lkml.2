Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab2DQXT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 19:19:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33620 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab2DQXTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 19:19:31 -0400
Message-ID: <4F8DFA7C.6080604@zytor.com>
Date: Tue, 17 Apr 2012 16:19:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: James Courtier-Dutton <james.dutton@gmail.com>
CC: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: malloc() failure counter
References: <CAAMvbhFCzKH-4_kspOfgCOEPZpsr1MVoVJogKmupF=FgtXE4GQ@mail.gmail.com>
In-Reply-To: <CAAMvbhFCzKH-4_kspOfgCOEPZpsr1MVoVJogKmupF=FgtXE4GQ@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 03:02 PM, James Courtier-Dutton wrote:
> Hi,
> 
> If I have a user application that tries a malloc() or a calloc() call,
> and this call fails, is there any way to report this to a global stats
> counter, like the ones in /proc/meminfo
> Is there any way to find out that a malloc call made by a user program failed?
> 

No, because that is an internal thing to glibc.

	-hpa

