Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725Ab2D0QYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:24:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38411 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760704Ab2D0QYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:24:40 -0400
Message-ID: <4F9AC806.60608@zytor.com>
Date: Fri, 27 Apr 2012 09:23:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        Arnd Bergmann <arnd@arndb.de>, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 1/2] asm-generic: io: remove {read,write} string functions
References: <1335523376-14695-1-git-send-email-will.deacon@arm.com>
In-Reply-To: <1335523376-14695-1-git-send-email-will.deacon@arm.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 03:42 AM, Will Deacon wrote:
> The {read,write}s{b,w,l} functions are not defined across all
> architectures and therefore shouldn't be used by portable drivers. We
> should encourage driver writers to use the io{read,write}{8,16,32}_rep
> functions instead.

Why is that?  ioread/write are great if the address space is undefined,
but do we need the extra overhead in any other cases?

	-hpa

