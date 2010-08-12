Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000Ab0HLOHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 10:07:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54183 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159Ab0HLOHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 10:07:33 -0400
Message-ID: <4C63FFB6.9080301@zytor.com>
Date: Thu, 12 Aug 2010 07:05:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Luca Barbieri <luca@luca-barbieri.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com,
        kd6lvw+software@kd6lvw.ampr.org, tglx@linutronix.de
Subject: Re: [tip:x86/urgent] x86, asm: Refactor atomic64_386_32.S to support
 old binutils and be cleaner
References: <tip-*@git.kernel.org>	<tip-30246557a06bb20618bed906a06d1e1e0faa8bb4@git.kernel.org> <AANLkTimoKzp17CXZhuRSSRH=FMqPyJjtvpBkSG8-8ZHN@mail.gmail.com>
In-Reply-To: <AANLkTimoKzp17CXZhuRSSRH=FMqPyJjtvpBkSG8-8ZHN@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2010 05:15 AM, Luca Barbieri wrote:
> Any reason you applied the older version I attached to the bug,
> instead of the second one?
> 
> NiTr0 reported an additional issue with this version you committed,
> which is solved by the second patch I attached.

I already had the first version queued up (I forgot to push it to the
public repository, however).  I'll just put in the incremental changes.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

