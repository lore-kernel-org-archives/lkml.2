Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab0HSVqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 17:46:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60787 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0HSVqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 17:46:38 -0400
Message-ID: <4C6DA620.7060009@zytor.com>
Date: Thu, 19 Aug 2010 14:46:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: fix BUG: using smp_processor_id() in preemptible code (resend)
References: <20100818091157.GA5238@swordfish.minsk.epam.com> <20100819170358.GD19773@amd.com>
In-Reply-To: <20100819170358.GD19773@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2010 10:03 AM, Roedel, Joerg wrote:
> 
> The notifier is preemtible so it can run on another CPU. So using the
> supplied cpu arguemnt in the path looks like the right solution to me.
> 

Sounds good -- Sergey, can you send a patch under cleaned up cover
(meaning just the one patch, with a description of why the change is the
right one)?

	-hpa

