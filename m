Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab2C2Lxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 07:53:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42482 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759078Ab2C2Lxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 07:53:35 -0400
Message-ID: <4F744D3B.3030605@linaro.org>
Date: Thu, 29 Mar 2012 12:53:31 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Grant Likely <grant.likely@secretlab.ca>, lrg@ti.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Board breakage due to upstream patch
References: <4F7430C7.6060505@linaro.org> <20120329110424.GD3668@opensource.wolfsonmicro.com>
In-Reply-To: <20120329110424.GD3668@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/03/12 12:04, Mark Brown wrote:
> On Thu, Mar 29, 2012 at 10:52:07AM +0100, Lee Jones wrote:
> 
>> Your patch "regulator: Support driver probe deferral" (below) prevents my Snowball Development Board from booting.
> 
>> What's the correct thing to do?
> 
> Provide a report with a little more detail on the problem:
> 
>    http://www.chiark.greenend.org.uk/~sgtatham/bugs.html
> 
> It's possible the patch I posted yesterday which fixes a deadlock in
> error handling paths might help, though given that all we're doing is
> changing the error code here I'd say regulator support on your your
> board was broken anyway.  Given the lack of any detail in your report
> I'm just guessing completely in the dark here.

I haven't undertaken any debugging of the issue, as I don't have the
time, nor do I have the knowledge to be able to tell you what might be
happening as a result of the change.

All I can tell you at this stage is that with your patch applied, my
board doesn't boot past "Uncompressing Linux... done, booting the
kernel..". Once reverted it boots again.

I'll try to find some time to have a dig around, in order to provide you
with some more useful information.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
