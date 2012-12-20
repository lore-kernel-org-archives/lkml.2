Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab2LTVDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 16:03:33 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50559 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2LTVD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 16:03:27 -0500
Message-ID: <50D37D1A.1030404@wwwdotorg.org>
Date: Thu, 20 Dec 2012 14:03:22 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Simon Glass <sjg@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>, Roland Stigge <stigge@antcom.de>,
        Vincent Palatin <vpalatin@chromium.org>, linux-doc@vger.kernel.org,
        Dmitry Torokhov <dtor@mail.ru>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Felipe Balbi <balbi@ti.com>,
        Luigi Semenzato <semenzato@chromium.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-input@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] RFC: input: Extend matrix-keypad device tree binding
References: <1356035039-21653-1-git-send-email-sjg@chromium.org>
In-Reply-To: <1356035039-21653-1-git-send-email-sjg@chromium.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 01:23 PM, Simon Glass wrote:
> Some matrix keypad drivers can support different numbers of rows and
> columns. Add a generic binding for these.

Oh, I thought num-rows/columns were already there!

Anyway, looks fine to me, so,
Reviewed-by: Stephen Warren <swarren@nvidia.com>

