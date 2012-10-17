Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab2JQSaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 14:30:07 -0400
Received: from natasha.panasas.com ([67.152.220.90]:50327 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab2JQSaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 14:30:05 -0400
Message-ID: <507EF918.5030004@panasas.com>
Date: Wed, 17 Oct 2012 11:29:44 -0700
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jim Rees <rees@umich.edu>
CC: Dave Jones <davej@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>,
        Sasha Levin <levinsasha928@gmail.com>, <Trond.Myklebust@netapp.com>,
        <davem@davemloft.net>, <linux-nfs@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Prevent kernel stack corruption on long values
 of flush
References: <1342476086-21638-1-git-send-email-levinsasha928@gmail.com> <20120718173913.GA1298@fieldses.org> <20120718200049.GA17964@umich.edu> <20120718203304.GA18540@redhat.com> <20120718205510.GA18374@umich.edu>
In-Reply-To: <20120718205510.GA18374@umich.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 01:55 PM, Jim Rees wrote:
> Dave Jones wrote:
> 
>   
>   Unsigned long isn't necessarily 32 bits.
>   On 64-bit systems %lu can be up to 18446744073709551615
> 
> Thanks.  You caught me thinking "Intel."  How embarrassing.

What? why even on Intel-64 long is 64bit. long is always the
same or bigger then a pointer (A pointer must always fit
in a long)

On the other hand int is 32bit in Intel-64 unlike some
other CPUs where int(s) may get to be 64bit as well.

Cheers
Boaz
