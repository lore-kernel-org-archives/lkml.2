Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab1BNBxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 20:53:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45720 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab1BNBxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 20:53:14 -0500
Message-ID: <4D588AEC.1040000@zytor.com>
Date: Sun, 13 Feb 2011 17:52:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: x32-abi@googlegroups.com, "H.J. Lu" <hjl.tools@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: X32 psABI status
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>	<201102132110.29630.arnd@arndb.de>	<AANLkTimZA1Npf0nJ8PF-2=8Oe2LXr_ShyBJNkf8Dn5S5@mail.gmail.com>	<4D584A49.80306@zytor.com> <20110213213325.7bcc1a59@lxorguk.ukuu.org.uk>
In-Reply-To: <20110213213325.7bcc1a59@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2011 01:33 PM, Alan Cox wrote:
>
> Who actually needs this new extra API - whats the justification for
> everyone having more crud dumping their kernels, more syscall paths
> (which are one of the most security critical areas) and the like.
>
> What are the benchmark numbers to justify this versus just using the
> existing kernel interfaces ?
>

That's what the prototype is meant to show.

	-hpa
