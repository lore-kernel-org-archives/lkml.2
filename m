Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab0CSXu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 19:50:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52087 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab0CSXu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 19:50:26 -0400
Message-ID: <4BA40C21.3090804@zytor.com>
Date: Fri, 19 Mar 2010 16:43:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v3] x86: do not free zero sized per cpu areas
References: <4B914A61.20409@kernel.org> <4BA3F82D.5090807@kernel.org>	 <4BA3F8ED.2090600@zytor.com>  <4BA407B8.7070503@kernel.org> <1269041758.28761.33.camel@localhost.localdomain>
In-Reply-To: <1269041758.28761.33.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 04:35 PM, Ian Campbell wrote:
> 
> I think Peter means:
> 
> if (start == end)
> return;
> 
> if (WARN_ONCE(start < end, "blah"))
> return;

start > end!

> i.e. silently ignore a zero sized region and verbosely ignore a
> negatively sized one.

Correct.

	-hpa
