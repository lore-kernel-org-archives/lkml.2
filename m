Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab0KVOby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 09:31:54 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53938 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab0KVObw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 09:31:52 -0500
Subject: Re: [PATCH 1/2] regulator: Fix obfuscated log messages
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
In-Reply-To: <1290433879-6184-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1290433879-6184-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 14:31:36 +0000
Message-ID: <1290436296.3309.55.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 13:51 +0000, Mark Brown wrote:
> Don't use %s to format fixed static strings into log messages, it just
> makes searching for and reading the message in the kernel source
> needlessly hard.

Both Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

