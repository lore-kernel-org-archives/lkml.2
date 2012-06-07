Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760721Ab2FGLEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 07:04:20 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:47061 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab2FGLET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 07:04:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAHdPZaMYnMCygOa+mcUMq0vwJpW7W1PE9AqKPkNGEeN0u-bF6w@mail.gmail.com>
References: <1338656634-3870-1-git-send-email-devendra.aaru@gmail.com>
	<CAHdPZaMYnMCygOa+mcUMq0vwJpW7W1PE9AqKPkNGEeN0u-bF6w@mail.gmail.com>
Date: Thu, 7 Jun 2012 13:04:18 +0200
Message-ID: <CACRpkda-iZchGtKUzeBxCKecKkvZBW_1LHRa5PyrZHpT9BMPxw@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: free allocated pinctrl_map structure only
 once and use kernel facilities for IMX_PMX_DUMP
From: Linus Walleij <linus.walleij@linaro.org>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 4, 2012 at 1:37 PM, devendra.aaru <devendra.aaru@gmail.com> wrote:

> Anybody Please??

Take it easy. Give the Freescalers some time to review...

If nothing happens for a week I'll just apply it so they can shout
if there's something wrong with it :-D

Linus
