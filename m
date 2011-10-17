Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1JQRla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:41:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34625 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab1JQRl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 13:41:29 -0400
Message-ID: <4E9C6886.20600@zytor.com>
Date: Mon, 17 Oct 2011 10:40:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Borislav Petkov <bp@amd64.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] Re: [PATCH 0/3] x86/microcode: support for microcode
 update in Xen dom0
References: <20111012101615.GA14966@aftab> <4E95D9E7.6090304@zytor.com> <4E95E7FE.6050302@goop.org> <20111012194543.GD14966@aftab> <20111012204048.GA22260@phenom.oracle.com> <4E960746.90805@zytor.com> <20111012214013.GD28723@aftab> <4E96198F.4030906@zytor.com> <20111013073352.GB501@aftab> <20111013095708.GA1862@aftab> <20111017170854.GE19756@phenom.dumpdata.com>
In-Reply-To: <20111017170854.GE19756@phenom.dumpdata.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2011 10:08 AM, Konrad Rzeszutek Wilk wrote:
> 
> <scratches his head>
> You are still using the microcode API (the existing one) to
> program the CPUs right? It is just that you are fetching the images
> much much earlier than it currently is done?
> 

No, the goal is to ditch the existing API and load the CPUs very early
in the start path.

	-hpa
