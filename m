Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab2DWP03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:26:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44640 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab2DWP01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:26:27 -0400
Message-ID: <4F95749E.40708@wwwdotorg.org>
Date: Mon, 23 Apr 2012 09:26:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Sourav Poddar <sourav.poddar@ti.com>
CC: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Benoit Cousson <b-cousson@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCHv3 1/2] drivers: input: keypad: Add device tree support
References: <1335194839-30193-1-git-send-email-sourav.poddar@ti.com>
In-Reply-To: <1335194839-30193-1-git-send-email-sourav.poddar@ti.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 09:27 AM, Sourav Poddar wrote:
> Update the Documentation with omap4 keypad device tree
> binding information.
> Add device tree support for omap4 keypad driver.

Shouldn't this use the already-defined matrix keyboard bindings at
Documentation/devicetree/bindings/input/matrix-keymap.txt?

(I asked this before, but don't recall seeing any response explaining
why a new binding was needed. Sorry if I missed it.)
