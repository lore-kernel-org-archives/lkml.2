Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab2G0Wn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 18:43:29 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47628 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab2G0Wn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 18:43:26 -0400
MIME-Version: 1.0
In-Reply-To: <1342603220-13287-1-git-send-email-peter.ujfalusi@ti.com>
References: <1342603220-13287-1-git-send-email-peter.ujfalusi@ti.com>
Date: Sat, 28 Jul 2012 00:43:26 +0200
Message-ID: <CACRpkdb36Xq1gdsTwaekWoHVD9i6tQdG3HgidEdsjH-8fYhbsg@mail.gmail.com>
Subject: Re: [PATCH 0/3] MFD/GPIO: Add twl6040 GPO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 11:20 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:

> Linus, Grant, Samuel: Would it be possible to queue this series via the MFD tree
> to avoid merge issues? It applies cleanly on top of gpio-next I believe it will
> not cause problems via MFD.

Sure, as soon as you have mine or Grants ACK on the GPIO stuff you
can ask Sam to queue it. But first, some review :-)

Linus Walleij
