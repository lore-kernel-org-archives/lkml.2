Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab1ACSaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 13:30:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46738 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab1ACSaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 13:30:11 -0500
Message-ID: <4D22159C.6080402@zytor.com>
Date: Mon, 03 Jan 2011 10:29:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix section mismatch in LAPIC initialization
References: <4D21F338020000780002A112@vpn.id2.novell.com>
In-Reply-To: <4D21F338020000780002A112@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2011 07:03 AM, Jan Beulich wrote:
> Doing things conditionally upon spm_processor_id() being zero is
> generally a bad idea, as this means CPU 0 cannot be offlined and
> brought back online later again. While there may be other places where
> this is done, I think adding more of those should be avoided so that
> some day SMP really becomes "symmetrical".
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

The description doesn't really match the subject line...

	-hpa
