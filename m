Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab2GZLXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:23:54 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:48840 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412Ab2GZLXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:23:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120726112237.GV3099@opensource.wolfsonmicro.com>
References: <1343298603-25442-1-git-send-email-kishon@ti.com>
	<20120726111030.GU3099@opensource.wolfsonmicro.com>
	<CAAe_U6LhrBnsU9nC0yXqyNmEjmDfrvYP5BYhAOhJiGxLZbk_Qw@mail.gmail.com>
	<20120726112237.GV3099@opensource.wolfsonmicro.com>
Date: Thu, 26 Jul 2012 16:53:50 +0530
Message-ID: <CAAe_U6Kwetj8KKaio6wEQp_Tmy6EZWftkxYfcqmmgq5xygNATA@mail.gmail.com>
Subject: Re: [RFC PATCH] drivers: regulator: add error checks for exported APIs
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: lrg@ti.com, balbi@ti.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 4:52 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Jul 26, 2012 at 04:49:21PM +0530, ABRAHAM, KISHON VIJAY wrote:
>> On Thu, Jul 26, 2012 at 4:40 PM, Mark Brown
>
>> > Also NULL is a valid regulator (though we don't use it right now).
>
>> I see a lot of dereferencing *regulator*. How is it supposed to work
>> when *regulator* is NULL?
>
> Like I say we don't use this now but the spec in the API is that
> anything except an error pointer is valid.

Ok.

Thanks
Kishon
