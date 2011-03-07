Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab1CGLqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:46:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59030 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754607Ab1CGLqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:46:32 -0500
Date: Mon, 7 Mar 2011 11:46:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mariusz Kozlowski <mk@lab.zgora.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: linux-next: Tree for March 4
Message-ID: <20110307114631.GD13471@opensource.wolfsonmicro.com>
References: <20110304180027.20deb6c4.sfr@canb.auug.org.au>
 <20110306225210.GA9085@mako-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110306225210.GA9085@mako-laptop>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 06, 2011 at 11:52:10PM +0100, Mariusz Kozlowski wrote:

> Looking at surrounding code it's missing ifdef for CONFIG_DEBUG_FS.

Yup, should be fixed now.
