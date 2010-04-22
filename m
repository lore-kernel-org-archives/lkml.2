Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab0DVGse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 02:48:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57973 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab0DVGsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 02:48:33 -0400
Message-ID: <4BCFF12D.60007@zytor.com>
Date: Wed, 21 Apr 2010 23:48:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: introduce and use percpu_inc()
References: <4BCFFA1B020000780005CBAE@vpn.id2.novell.com>
In-Reply-To: <4BCFFA1B020000780005CBAE@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2010 11:26 PM, Jan Beulich wrote:
> 
>> Keep in mind that although INC is smaller than ADD,
>> the former has flag dependencies that the latter doesn't...
> 
> Wasn't that a problem just on Pentium4-s, which when I submitted
> another related patch a couple of months back I was told would
> not be a primary target anymore?
> 

It doesn't look like it, from what I could tell after the abovementioned
conversation... I was wondering mostly how many bytes this saved across
the kernel.  If it saves a byte in one place it's not so interesting,
but if it is all over it might make more sense.

It bit much worse on P4 than on most other cores, though.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

