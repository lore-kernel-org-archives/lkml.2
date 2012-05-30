Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab2E3Gfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 02:35:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65084 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab2E3Gfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 02:35:50 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 6/6] pinctrl: add pinctrl gpio binding support
To: Stephen Warren <swarren@wwwdotorg.org>,
        Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com
In-Reply-To: <4FBFBB74.901@wwwdotorg.org>
References: <1337952980-14621-1-git-send-email-b29396@freescale.com> <1337952980-14621-6-git-send-email-b29396@freescale.com> <4FBFBB74.901@wwwdotorg.org>
Date: Wed, 30 May 2012 14:35:46 +0800
Message-Id: <20120530063547.01BD83E065C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012 11:03:48 -0600, Stephen Warren <swarren@wwwdotorg.org> wrote:
> I believe Grant wants to change the of_xlate prototype in order to be
> able to return a different gc value, so this will probably need slight
> rework work with that change, once they're both approved. Still, I think
> this is fine for now.

I took a different approach.  Now multiple gpio_chips can use the same
of node, and of_xlate needs to match on the entire gpio specifier, not
just the node.  This code is now in mainline.

g.

