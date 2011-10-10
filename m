Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab1JJJcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 05:32:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54453 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097Ab1JJJcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 05:32:42 -0400
Date: Mon, 10 Oct 2011 10:32:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Michael Opdenacker <michael.opdenacker@linaro.org>
Cc: jarkko.nikula@bitmer.com, lrg@ti.com, perex@perex.cz, tiwai@suse.de,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] omap: sound: fix checkpatch.pl error
Message-ID: <20111010093240.GB3040@opensource.wolfsonmicro.com>
References: <1318223228-15671-1-git-send-email-michael.opdenacker@linaro.org>
 <1318223228-15671-3-git-send-email-michael.opdenacker@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318223228-15671-3-git-send-email-michael.opdenacker@linaro.org>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 07:07:08AM +0200, Michael Opdenacker wrote:
> Signed-off-by: Michael Opdenacker <michael.opdenacker@linaro.org>

Applied, but please do try to make sure your changelogs resemble those
for the rest of the subsystem.  Especially for trivial patches it's not
good to increase the effort required to apply them.
