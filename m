Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0IVVe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 17:34:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59430 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab0IVVe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 17:34:29 -0400
Message-ID: <4C9A764B.5030600@zytor.com>
Date: Wed, 22 Sep 2010 14:34:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: tidy e820 output
References: <20100922172744.19085.41844.stgit@bob.kio> <201009221311.19567.bjorn.helgaas@hp.com> <4C9A6FF4.2060201@kernel.org> <201009221522.06873.bjorn.helgaas@hp.com>
In-Reply-To: <201009221522.06873.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 02:22 PM, Bjorn Helgaas wrote:
> 
> I decided the code simplification was worth skipping the type.
> I'd certainly rather have the type value, too, but I don't know
> how much hassle to go through to debug a firmware problem.  How
> important do you think it is?
> 

Very.  New types get introduced periodically.

	-hpa
