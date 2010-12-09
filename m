Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab0LIK4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 05:56:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36048 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755523Ab0LIK4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 05:56:31 -0500
Date: Thu, 9 Dec 2010 10:56:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: fix deemphasis control in wm8904/55/60 codecs
Message-ID: <20101209105626.GA4548@rakim.wolfsonmicro.main>
References: <1291840577-23908-1-git-send-email-mad_soft@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291840577-23908-1-git-send-email-mad_soft@inbox.ru>
X-Cookie: So this is it.  We're going to die.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 11:36:17PM +0300, Dmitry Artamonow wrote:
> Deemphasis control's .get callback should update control's value instead
> of returning it - return value of callback function is used for indicating
> error or success of operation.
> 
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>

Applied, thanks.
