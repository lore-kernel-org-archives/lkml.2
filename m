Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab0DVP3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 11:29:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab0DVP3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 11:29:04 -0400
Message-ID: <4BD06B31.9050306@redhat.com>
Date: Thu, 22 Apr 2010 18:28:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
       hugh.dickins@tiscali.co.uk, ngupta@vflare.org, JBeulich@novell.com,
       chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, npiggin@suse.de, akpm@linux-foundation.org,
       riel@redhat.com
Subject: Re: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
References: <20100422134249.GA2963@ca-server1.us.oracle.com>
In-Reply-To: <20100422134249.GA2963@ca-server1.us.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2010 04:42 PM, Dan Magenheimer wrote:
> Frontswap is so named because it can be thought of as the opposite of
> a "backing" store for a swap device.  The storage is assumed to be
> a synchronous concurrency-safe page-oriented pseudo-RAM device (such as
> Xen's Transcendent Memory, aka "tmem", or in-kernel compressed memory,
> aka "zmem", or other RAM-like devices) which is not directly accessible
> or addressable by the kernel and is of unknown and possibly time-varying
> size.  This pseudo-RAM device links itself to frontswap by setting the
> frontswap_ops pointer appropriately and the functions it provides must
> conform to certain policies as follows:
>    

How baked in is the synchronous requirement?  Memory, for example, can 
be asynchronous if it is copied by a dma engine, and since there are 
hardware encryption engines, there may be hardware compression engines 
in the future.


-- 
error compiling committee.c: too many arguments to function

