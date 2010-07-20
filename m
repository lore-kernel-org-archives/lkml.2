Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947Ab0GTUHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:07:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53486 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab0GTUHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:07:00 -0400
Message-ID: <4C4601C1.9000201@zytor.com>
Date: Tue, 20 Jul 2010 13:06:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, numa: fix boot without RAM on node0 again
References: <4C45EC59.3030304@kernel.org>	<4C45F5F0.8010409@zytor.com> <20100720122831.f1aad864.akpm@linux-foundation.org>
In-Reply-To: <20100720122831.f1aad864.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 12:28 PM, Andrew Morton wrote:
> 
> And this patch is missing my patch which fixed up that block comment.
> 
> I'll send both these patches into Linus today.  I'm a bit behind due to
> various linux-next catastrophies.
> 
> Catastrophies which have been known about for up to a week, yet all the
> offending patches are still in linux-next, unaltered.  Go figure.
> 

Thank you.

	-hpa
