Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966986Ab2EQXcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 19:32:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38498 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965781Ab2EQXcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 19:32:07 -0400
Message-ID: <4FB58A6A.6020601@zytor.com>
Date: Thu, 17 May 2012 16:31:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: "H.J. Lu" <hjl.tools@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@kernel.org, tglx@linutronix.de
Subject: Re: [RFC PATCH 00/10] Use __kernel_[u]long_t for x32 user space compatibility
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <4FB584C0.6080807@gmail.com> <4FB585B8.2010607@zytor.com> <4FB58901.5060604@gmail.com>
In-Reply-To: <4FB58901.5060604@gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 04:25 PM, David Daney wrote:
>>
>> Do you have any basis whatsoever for that statement?
> 
> You should have asked for a 'solid basis'.
> 
> My basis is that the name '__kernel_ulong_t' implies, in my mind, that
> it would have the width of a kernel unsigned long.

The namespace __kernel_* doesn't mean "as used in the kernel" but rather
"exported by the kernel".  But yes, see also Linus' criticism.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

