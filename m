Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab1GJXIE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 19:08:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47754 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab1GJXIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 19:08:01 -0400
Date: Sun, 10 Jul 2011 16:07:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Edwin van Vliet <edwin@cheatah.nl>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers/input/tablet/aiptek: removed double define
Message-ID: <20110710230754.GA29533@core.coreip.homeip.net>
References: <1310336441-26893-1-git-send-email-edwin@cheatah.nl>
 <alpine.LNX.2.00.1107110031220.2818@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1107110031220.2818@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 12:31:50AM +0200, Jesper Juhl wrote:
> On Mon, 11 Jul 2011, Edwin van Vliet wrote:
> 
> > Constant AIPTEK_TOOL_BUTTON_PEN_MODE was diefined twice
> > 
> > Signed-off-by: Edwin van Vliet <edwin@cheatah.nl>
> > ---
> >  drivers/input/tablet/aiptek.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
> > index 0a619c5..6d89fd1 100644
> > --- a/drivers/input/tablet/aiptek.c
> > +++ b/drivers/input/tablet/aiptek.c
> > @@ -225,7 +225,6 @@
> >  	/* toolMode codes
> >  	 */
> >  #define AIPTEK_TOOL_BUTTON_PEN_MODE			BTN_TOOL_PEN
> > -#define AIPTEK_TOOL_BUTTON_PEN_MODE			BTN_TOOL_PEN
> >  #define AIPTEK_TOOL_BUTTON_PENCIL_MODE			BTN_TOOL_PENCIL
> >  #define AIPTEK_TOOL_BUTTON_BRUSH_MODE			BTN_TOOL_BRUSH
> >  #define AIPTEK_TOOL_BUTTON_AIRBRUSH_MODE		BTN_TOOL_AIRBRUSH
> > 
> Reviewed-by: Jesper Juhl <jj@chaosbits.net>

Applied, thanks.

-- 
Dmitry
