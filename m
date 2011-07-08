Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab1GHNH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 09:07:28 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:40177 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab1GHNHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 09:07:25 -0400
Date: Fri, 8 Jul 2011 17:07:21 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/3] power_supply: Support multiple wm831x_backup
 instances
Message-ID: <20110708130721.GB29056@oksana.dev.rtsoft.ru>
References: <1308658125-25013-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1308658125-25013-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1308658125-25013-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 01:08:44PM +0100, Mark Brown wrote:
> If there are multiple wm831x devices in the system we need to assign
> different names to the power supply devices in order to ensure we can
> create the sysfs entries for them.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---

All three applied, thanks.
