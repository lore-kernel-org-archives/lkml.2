Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab2BVWpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 17:45:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52912 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab2BVWpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 17:45:30 -0500
Message-ID: <4F457000.2010705@intel.com>
Date: Wed, 22 Feb 2012 14:45:20 -0800
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
Organization: Intel Corporation
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org> <4F456D8F.1080801@zytor.com>
In-Reply-To: <4F456D8F.1080801@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 02:34 PM, H. Peter Anvin wrote:
> 
> Okay, this patchset does *NOT* work.  It fails immediately on my system.
>  I hadn't ever seen it fail so fast.
> 

That was testing on top of 3.2.7, fwiw.

	-hpa

