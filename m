Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab0IVWHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 18:07:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50579 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab0IVWHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 18:07:47 -0400
Message-ID: <4C9A7E1C.4080509@zytor.com>
Date: Wed, 22 Sep 2010 15:07:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: tidy e820 output
References: <20100922172744.19085.41844.stgit@bob.kio> <201009221522.06873.bjorn.helgaas@hp.com> <4C9A764B.5030600@zytor.com> <201009221605.21447.bjorn.helgaas@hp.com>
In-Reply-To: <201009221605.21447.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 03:05 PM, Bjorn Helgaas wrote:
> 
> OK, I managed to overcome my aversion to KERN_CONT to try again:
> 

If you don't want to use KERN_CONT there is always sprintf.

	-hpa
