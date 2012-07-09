Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab2GIOwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:52:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35885 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000Ab2GIOwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:52:53 -0400
Message-ID: <4FFAF042.1050609@gmail.com>
Date: Mon, 09 Jul 2012 08:52:50 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
References: <4FFAE6D8.5050609@gmail.com> <20120709141904.GC7298@redhat.com>  <1341843844.3462.75.camel@twins> <4FFAED16.7050204@redhat.com>  <4FFAEF13.7010108@gmail.com> <1341845396.3462.81.camel@twins>
In-Reply-To: <1341845396.3462.81.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/12 8:49 AM, Peter Zijlstra wrote:
> On Mon, 2012-07-09 at 08:47 -0600, David Ahern wrote:
>>
>> I found this testing changes to perf-kvm, but found the problem extends
>> to just perf-record. With perf-record exclude_guest defaults to 1. See
>> tools/perf/util/util.c, event_attr_init().
>
> You lost me there.. so perf-record defaults to exclude_guest=1 (which
> would make the proposed patch I just send actually possible), but its
> still going *bang* ?
>


I can do the formality of testing your proposed patch, but yes I think 
so. exclude_guest defaults to 1 because perf_guest defaults to false.

David
