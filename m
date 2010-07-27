Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab0G0Q36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:29:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45384 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab0G0Q34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:29:56 -0400
Message-ID: <4C4F0963.70602@zytor.com>
Date: Tue, 27 Jul 2010 09:29:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/irq] x86: Always use irq stacks
References: <20100630074434.GA25509@elte.hu> <20100630075212.GA24658@lst.de> <20100630075818.GB25509@elte.hu> <20100630080453.GA14371@elte.hu> <20100708204251.GA13569@elte.hu> <20100708205302.GA23961@lst.de> <20100714151215.GA31825@lst.de> <alpine.LFD.2.00.1007141719130.3321@localhost.localdomain> <20100714154746.GA2074@lst.de> <1279131672.4190.18.camel@localhost> <20100727121313.GA19976@lst.de>
In-Reply-To: <20100727121313.GA19976@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 05:13 AM, Christoph Hellwig wrote:
> Ingo, can you test this patch implementing Steve's suggestion?
> Unfortunately I'm not able to reproduce the bug on my setup anymore.

Ingo is on vacation this week, but regardless of it it fixes the problem
it is absolutely necessary.  As far as reproducing -- without it you get
a 50% build time chance to get a working kernel...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

