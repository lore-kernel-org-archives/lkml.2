Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0HSVXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 17:23:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45534 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab0HSVXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 17:23:30 -0400
Message-ID: <4C6DA0C0.6020808@zytor.com>
Date: Thu, 19 Aug 2010 14:23:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: "D. Stussy" <kd6lvw@verizon.net>
CC: linux-tip-commits@vger.kernel.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org, luca@luca-barbieri.com,
        tglx@linutronix.de
Subject: Re: [tip:x86/urgent] x86, asm: Refactor atomic64_386_32.S to support
 old binutils and be cleaner
References: <85878.24188.qm@web84204.mail.re3.yahoo.com>
In-Reply-To: <85878.24188.qm@web84204.mail.re3.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2010 12:06 PM, D. Stussy wrote:
> Has this patch been posted to the 2.6.35 kernel also, or just to 2.6.36?  I don't think it's been posted to 2.6.35 where the problem it corrects was introduced.
> 
> "Greg KH" <gregkh@suse.de> has made a last call (tomorrow - Aug 20) for chnges for 2.6.35.3 and doesn't seem to have this.  It's not in the prior two updates either.....

It was Cc: <stable@kernel.org>; it's up to Greg to include it or not.

[Greg: 30246557a06bb20618bed906a06d1e1e0faa8bb4]

	-hpa
