Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0LTIyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 03:54:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab0LTIyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 03:54:36 -0500
Message-ID: <4D0F19C2.4070906@redhat.com>
Date: Mon, 20 Dec 2010 10:54:26 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, kvm@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 17 (kvm)
References: <20101217173237.fe1de00a.sfr@canb.auug.org.au> <20101217111052.8bba9060.randy.dunlap@oracle.com>
In-Reply-To: <20101217111052.8bba9060.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 09:10 PM, Randy Dunlap wrote:
> On Fri, 17 Dec 2010 17:32:37 +1100 Stephen Rothwell wrote:
>
> >  Hi all,
> >
> >  [The mirroring on kernel.org is running slowly]
> >
> >  Changes since 20101216:
>
>
> on i386 builds, I'm seeing this build error:
>
> arch/x86/kvm/vmx.c:488: Error:bad register name `%sil'
>
> but I don't see what is causing it...
>

"=g" needs to be "=qQm"  in vmcs_load().  I'll post a patch.

-- 
error compiling committee.c: too many arguments to function

