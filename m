Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab0KGOnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 09:43:15 -0500
Received: from lo.gmane.org ([80.91.229.12]:40021 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab0KGOnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 09:43:14 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: Re: Linux kernel compression with lrzip
Date: Sun, 07 Nov 2010 19:42:52 +0500
Message-ID: <4CD6BAEC.2070605@gmail.com>
References: <201011072259.25625.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 90.151.108.230
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101029 Lightning/1.0b3pre Thunderbird/3.1.6
In-Reply-To: <201011072259.25625.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07.11.2010 16:59, Con Kolivas wrote:
> Lrzip
> was a project I began based on rzip which tried to extend the initial
> compression window beyond 900MB and to use lzma as the back end for the 2nd
> stage compression.

<snip>

> Starting with linux kernel 2.6.36
>
> 413511680 linux-2.6.36.tar
> 70277083 linux-2.6.36.tar.bz2
> 59905365 linux-2.6.36.tar.lrz

So, why are you comparing to tar.bz2, if you use lzma as the backend? 
I.e. this benchmark does nothing to show the benefit from the 
preprocessing stage. Please compare to tar.lzma instead.

-- 
Alexander E. Patrakov

