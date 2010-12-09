Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab0LIKEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 05:04:43 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52702 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab0LIKEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 05:04:42 -0500
Subject: Re: [PATCH] ASoC: fix deemphasis control in wm8904/55/60 codecs
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <1291840577-23908-1-git-send-email-mad_soft@inbox.ru>
References: <1291840577-23908-1-git-send-email-mad_soft@inbox.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 10:04:38 +0000
Message-ID: <1291889078.3271.16.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 23:36 +0300, Dmitry Artamonow wrote:
> Deemphasis control's .get callback should update control's value instead
> of returning it - return value of callback function is used for indicating
> error or success of operation.
> 
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> ---

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

