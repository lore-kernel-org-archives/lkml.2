Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab1D0Ht1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 03:49:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088Ab1D0HtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 03:49:25 -0400
Message-ID: <4DB7CA7B.1000603@redhat.com>
Date: Wed, 27 Apr 2011 10:49:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, kvm@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: linux-next: Tree for April 26 (kvm)
References: <20110426202605.c66ce0ea.sfr@canb.auug.org.au> <20110426083940.934e0e6f.randy.dunlap@oracle.com>
In-Reply-To: <20110426083940.934e0e6f.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2011 06:39 PM, Randy Dunlap wrote:
> On Tue, 26 Apr 2011 20:26:05 +1000 Stephen Rothwell wrote:
>
> >  Hi all,
> >
> >  The kernel.org mirroring is being very slow today.
>
> on i386:
>
> ERROR: "__get_user_X" [arch/x86/kvm/kvm.ko] undefined!

Thanks, this has already been noted; we'll fix this shortly.

-- 
error compiling committee.c: too many arguments to function

