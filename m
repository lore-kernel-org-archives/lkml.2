Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995Ab1LPPj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 10:39:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49104 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324Ab1LPPjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 10:39:49 -0500
Message-ID: <4EEB662A.9070308@zytor.com>
Date: Fri, 16 Dec 2011 07:39:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix and improve percpu_cmpxchg{8,16}b_double()
References: <4EE86D6502000078000679FE@nat28.tlf.novell.com>
In-Reply-To: <4EE86D6502000078000679FE@nat28.tlf.novell.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 12:33 AM, Jan Beulich wrote:
> 
> At once also change the return value type to what it really is -
> 'bool'.
> 

I have a hazy memory of "bool" not working correctly in inline assembly,
but it might be ancient history by now.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

