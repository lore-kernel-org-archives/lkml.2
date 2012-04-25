Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab2DYQp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:45:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62059 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab2DYQpy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:45:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120425095819.GG3195@opensource.wolfsonmicro.com>
References: <20120423110522.GB8318@opensource.wolfsonmicro.com>
	<4F95495D.4050508@stericsson.com>
	<20120423122555.GM8318@opensource.wolfsonmicro.com>
	<4F954ED6.2040201@stericsson.com>
	<20120423180140.GR8318@opensource.wolfsonmicro.com>
	<4F965FC4.7010502@stericsson.com>
	<20120424105603.GA12063@opensource.wolfsonmicro.com>
	<4F969FE8.7040500@stericsson.com>
	<20120425080226.GA3195@opensource.wolfsonmicro.com>
	<4F97C5E0.1050808@stericsson.com>
	<20120425095819.GG3195@opensource.wolfsonmicro.com>
Date: Wed, 25 Apr 2012 22:15:53 +0530
Message-ID: <CABb+yY0ViFzxWOi7adaGNQPJvCy3e7MHd1+HGKkq8DZhtj9Anw@mail.gmail.com>
Subject: Re: [PATCH] regulator: core: Keep boot_on regulators powered during init
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ulf Hansson <ulf.hansson@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 3:28 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Apr 25, 2012 at 11:37:36AM +0200, Ulf Hansson wrote:
>
>> Maybe you have convinced me now :-) I will therefore start thinking
>> of a patch on the mmc framework instead. I will include you if/when
>> I send out the patch to the mmc-list, just for reference if that is
>> ok with you?
>
> Yes, please - there've been some issues with the way regulators are used
> in MMC for a while.  There's definitely some stuff that needs to be
> worked through here.
>
> I've also added Jassi who it just occurred to me was talking about some
> vaugley similar stuff relatively recently (though I'm not sure it was
> MMC).  Jassi, the issue here is working out if an MMC device is powered
> at boot so we can skip probing then shutting it down cleanly.
>
Mark, thanks for notifying me.
But my problem was purely related to dummy - I wanted to determine if
a supply is physically absent when I have support for dummy regulator enabled.
