Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab2CSWng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:43:36 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43161 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab2CSWne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:43:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120319223729.GC3852@pengutronix.de>
References: <1331651129-30540-1-git-send-email-alexg@meprolight.com>
	<4F67AD31.8030500@redhat.com>
	<4F67B077.5050300@redhat.com>
	<20120319223729.GC3852@pengutronix.de>
Date: Mon, 19 Mar 2012 19:43:32 -0300
Message-ID: <CAOMZO5B=Qpng68xLmxGaHMqSmYzbkpObVcjHDQSXaXcz5s6gMQ@mail.gmail.com>
Subject: Re: [PATCH v1] i.MX35-PDK: Add Camera support
From: Fabio Estevam <festevam@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, fabio.estevam@freescale.com,
        linux-kernel@vger.kernel.org, Alex Gershgorin <alexg@meprolight.com>,
        g.liakhovetski@gmx.de, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On Mon, Mar 19, 2012 at 7:37 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:

> It's scheduled there. I should have responded with an applied message.

Please apply this one too: http://patchwork.ozlabs.org/patch/144942/

Otherwise camera device cannot register.
