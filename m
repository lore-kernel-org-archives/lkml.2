Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab2BPU6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 15:58:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34475 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089Ab2BPU6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 15:58:45 -0500
Message-ID: <4F3D6DE6.4080209@zytor.com>
Date: Thu, 16 Feb 2012 12:58:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: David Howells <dhowells@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 15/21] powerpc: Use generic posix_types.h
References: <1328677745-20121-16-git-send-email-hpa@zytor.com>  <1328677745-20121-1-git-send-email-hpa@zytor.com>  <3399.1329399884@redhat.com> <1329423997.2892.20.camel@pasglop>
In-Reply-To: <1329423997.2892.20.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 12:26 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2012-02-16 at 13:44 +0000, David Howells wrote:
>> PowerPC exports __FD_SET() and co. to userspace under some circumstances,
>> therefore this patch potentially breaks the userspace ABI.  Is this okay, Ben?
>
> I don't know why we would need that in userspace, unless some tools I
> don't know about exploit them (hint: there shouldn't be)
>
> I'm happy to remove them and see if anybody complains.
>

I think they are cut-and-paste from the old libc5-enabled i386.  Note 
that __GNUC__ disables it.

	-hpa

