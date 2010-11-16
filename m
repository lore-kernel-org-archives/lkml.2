Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039Ab0KPBRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 20:17:22 -0500
Received: from claw.goop.org ([74.207.240.146]:39374 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758942Ab0KPBRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 20:17:21 -0500
Message-ID: <4CE1DBA0.4010302@goop.org>
Date: Mon, 15 Nov 2010 17:17:20 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/3] xen/microcode: partially enable even
 for non-privileged kernels
References: <cover.1289519130.git.jeremy.fitzhardinge@citrix.com>	<049ad0809c51dedebab0b8e4bfcf58f5f26375b7.1289519130.git.jeremy.fitzhardinge@citrix.com> <20101115160245.GD345@dumpdata.com>
In-Reply-To: <20101115160245.GD345@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 08:02 AM, Konrad Rzeszutek Wilk wrote:
> On Thu, Nov 11, 2010 at 03:58:06PM -0800, Jeremy Fitzhardinge wrote:
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> Don't attempt to load microcode on non-privileged kernels.  Kernels
> The previous patch had this:
>
>  if (!xen_initial_domain())
> +               return NULL;
>
> which pretty much made non-priviliged kernels not do any micro code loading.
>
> It sounds like this patch is just to not compile the Xen microcode code
> if CONFIG_DOM0 is not enabled?

Yeah, I think the patch is a brainfart, and the existing code already
did the right thing.

    J
