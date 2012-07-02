Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab2GBSJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:09:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36026 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261Ab2GBSJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:09:32 -0400
Message-ID: <4FF1E37D.7050103@zytor.com>
Date: Mon, 02 Jul 2012 11:07:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Arnd Bergmann <arnd@arndb.de>, Alessandro Rubini <rubini@gnudd.com>,
        linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, linux@arm.linux.org.uk, x86@kernel.org,
        gregkh@linuxfoundation.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH V2 5/6] x86: add CONFIG_ARM_AMBA, selected by STA2X11
References: <4FECB95D.7010200@zytor.com> <20120701104401.GA4352@mail.gnudd.com> <2b797c83-6a3c-4051-841a-a4cfa9d1cae1@email.android.com> <201207021658.27755.arnd@arndb.de> <20120702180518.GA25995@sirena.org.uk>
In-Reply-To: <20120702180518.GA25995@sirena.org.uk>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 11:05 AM, Mark Brown wrote:
> On Mon, Jul 02, 2012 at 04:58:27PM +0000, Arnd Bergmann wrote:
> 
>> Also, in many cases it's possible to say specifically what some code depends
>> on. E.g. if a driver uses clk_get/clk_put, it should depend on CLKDEV_LOOKUP,
>> not on !X86.
> 
> Or we could get the stubs merged, or x86 could enable the clock API...
> 

If there is a dependency there it should be registered, regardless if
x86 enables the clock API.

Last I saw I saw a patch to that effect, asked what the benefit was, and
got no answer.

	-hpa


