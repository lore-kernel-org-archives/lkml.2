Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750941Ab2C1EMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 00:12:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49577 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab2C1EMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 00:12:08 -0400
Message-ID: <4F728F8D.1010505@zytor.com>
Date: Tue, 27 Mar 2012 21:11:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Disintegrate asm/system.h for X86
References: <20120327153424.23373.25880.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120327153424.23373.25880.stgit@warthog.procyon.org.uk>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2012 08:34 AM, David Howells wrote:
> Disintegrate asm/system.h for X86.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: x86@kernel.org

Acked-by: H. Peter Anvin <hpa@zytor.com>

Are you planning to push this as part of a bigger set or do you want me
to pick up this one?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

