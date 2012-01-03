Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab2ACI1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 03:27:01 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39680 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab2ACI07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 03:26:59 -0500
MIME-Version: 1.0
In-Reply-To: <20120102181313.GA27875@opensource.wolfsonmicro.com>
References: <1325483675-21908-1-git-send-email-thomas.abraham@linaro.org>
	<1325483675-21908-2-git-send-email-thomas.abraham@linaro.org>
	<20120102115959.GG2899@opensource.wolfsonmicro.com>
	<CAJuYYwQrfp6R=kSzXr6y0unDk9FtNxoy3Lt5QabdNMg9Qux=bg@mail.gmail.com>
	<20120102181313.GA27875@opensource.wolfsonmicro.com>
Date: Tue, 3 Jan 2012 13:56:58 +0530
Message-ID: <CAJuYYwSAsPYibZsgdHQzMba-wCymRxqqcmtZSZi7A_AzTJv5tg@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/4] lcd: platform-lcd: Eliminate need for platform data
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, jg1.han@samsung.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 January 2012 23:43, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Jan 02, 2012 at 11:21:46PM +0530, Thomas Abraham wrote:
>
>> Your point on maintaining support for both old and new formats is
>> helpful. But I am not sure if maintaining support for both formats is
>> the right thing to do. As most of the ARM platforms will switch to
>> using dt, maybe converting all of them to new format would be better.
>> I will try doing this and prepare a patch.
>
> There's more architectures than ARM supported in Linux and only a
> minority of them are using device tree at the minute.  Unless every
> architecture switches over platform data based users will still need to
> be supported.

I will try to retain the old platform data style also since there are
support for lcd panels in mainline that use 2 or more gpios in a panel
specific way. And it would be difficult to fold them into a generic
lcd type for lcd power control.

Thanks,
Thomas.
