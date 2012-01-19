Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab2ASOpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:45:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36483 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab2ASOpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:45:06 -0500
Message-ID: <4F182C55.7040305@zytor.com>
Date: Thu, 19 Jan 2012 06:44:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        tglx@linutronix.de, luca@luca-barbieri.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ix86: atomic64 assembly improvements
References: <4F16E41B020000780006D7A5@nat28.tlf.novell.com> <4F16F505.8040809@zytor.com> <4F170679020000780006D85B@nat28.tlf.novell.com> <4F1705A8.301@zytor.com> <4F17EDE9020000780006D97A@nat28.tlf.novell.com>
In-Reply-To: <4F17EDE9020000780006D97A@nat28.tlf.novell.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 01:18 AM, Jan Beulich wrote:
> 
> But the code is supposed to be correct even when caches are disabled
> (in which case LOCK# will continue to be used even on modern CPUs),
> and this case clearly isn't covered by the current implementation. It
> may be a good idea to adjust the patch description accordingly, but I
> see no reason to change the patch itself.
> 

It doesn't have anything to do with caches on or off.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

