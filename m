Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab2GOIHl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 04:07:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab2GOIH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 04:07:28 -0400
Message-ID: <50027A36.9070509@redhat.com>
Date: Sun, 15 Jul 2012 11:07:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
References: <1341845396.3462.81.camel@twins> <4FFAEFF1.9000706@redhat.com> <1341845999.3462.86.camel@twins> <4FFCBD00.1030109@gmail.com> <20120711071006.GF23898@redhat.com> <1342000187.3462.134.camel@twins> <20120711095337.GJ23898@redhat.com> <4FFE4E8D.90606@gmail.com> <20120712042923.GG7298@redhat.com> <4FFEEB55.5070009@gmail.com> <20120712160634.GI7298@redhat.com>
In-Reply-To: <20120712160634.GI7298@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 07:06 PM, Gleb Natapov wrote:
>> 
>> Note the :pH this time.
> I am not sure what perf kvm does with :pH modifier, but H modifier does
> not make sense with perf kvm and should be reported as an error by perf tool.

Maybe it should refer to the guest vs. the nested guest...

Well that's a horrible UI but we do need some way to distinguish among
the two.  Samples from the nested guest's kernel will make no sense when
looking at the guest kernel.  I guess we should default to exclude
nested guest mode.

-- 
error compiling committee.c: too many arguments to function


