Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab1ISJ1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:27:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62731 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab1ISJ1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 05:27:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110917155615.GT3523@ponder.secretlab.ca>
References: <20110916181220.E12109D401C@zog.reactivated.net>
	<20110917155615.GT3523@ponder.secretlab.ca>
Date: Mon, 19 Sep 2011 10:27:07 +0100
X-Google-Sender-Auth: 6X6uXO-IW5RYO1EE8ReSY0uRenE
Message-ID: <CAMLZHHQqqs6k2i-RCSJ0YkZ2keVNPNQV9EbVccxUW1kjUq6f_Q@mail.gmail.com>
Subject: Re: [PATCH v2 RESEND 2] gpio-vx855: add device tree binding
From: Daniel Drake <dsd@laptop.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Thanks for looking at this.

On Sat, Sep 17, 2011 at 4:56 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> drivers/mfd/vx855.c should be modified to assign pdev->of_node, which
> can be used here for setting up c->of_node.

There doesn't seem to be any obvious place in mfd/vx855.c to insert
this. All the platform device creation and addition is done inside the
mfd layer (e.g. mfd_add_device()). Should I look at extending the MFD
API to allow for of_nodes to be passed in?

Thanks,
Daniel
