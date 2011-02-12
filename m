Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1BLXEY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 18:04:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49341 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab1BLXEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 18:04:20 -0500
Message-ID: <4D5711E0.7020306@zytor.com>
Date: Sat, 12 Feb 2011 15:04:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: x32-abi@googlegroups.com
CC: Florian Weimer <fw@deneb.enyo.de>, "H.J. Lu" <hjl.tools@gmail.com>,
        GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: X32 psABI status
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com> <87aai1gdr7.fsf@mid.deneb.enyo.de>
In-Reply-To: <87aai1gdr7.fsf@mid.deneb.enyo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2011 01:10 PM, Florian Weimer wrote:
> Why is the ia32 compatiblity kernel interface used?

Because there is no way in hell we're designing in a second
compatibility ABI in the kernel (and it has to be a compatibility ABI,
because of the pointer size difference.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

