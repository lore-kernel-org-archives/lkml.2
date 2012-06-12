Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab2FLO1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:27:16 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:60555 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab2FLO1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:27:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAHdPZaMEiJrDdw66KkODd_VuomV0TY6qPZn1z_W48j++ed5YJA@mail.gmail.com>
References: <1339183331-4108-1-git-send-email-devendra.aaru@gmail.com>
	<CACRpkdb0TefNMcXyTRkz6Kv5FifJMmSoXzFTQgKhCt6B0T5sDA@mail.gmail.com>
	<CAHdPZaMEiJrDdw66KkODd_VuomV0TY6qPZn1z_W48j++ed5YJA@mail.gmail.com>
Date: Tue, 12 Jun 2012 16:27:11 +0200
Message-ID: <CACRpkdZji5DDoK=GEyCq5QJgksLYJsbgTCCU=dYA1i3Q0SXMqw@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: pinctrl-imx: free allocated pinctrl_map
 structure only once and use kernel facilities for IMX_PMX_DUMP
From: Linus Walleij <linus.walleij@linaro.org>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: Dong Aisheng <aisheng.dong@freescale.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 2:34 PM, devendra.aaru <devendra.aaru@gmail.com> wrote:

> so for every review, do we need to increment version count of the patch?

No, just make sure I can understand which is the latest one... any way you
want :-)

Linus Walleij
