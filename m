Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab0JYEvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 00:51:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51719 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab0JYEvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 00:51:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jS8cFeWO7oQqK3o/X0tmISKSb6Xp3Zkvmw0LdpfC7wlwfjApbNFdaKnK4v6CxfAQHL
         GSvxJE7GaU0LyG4t+sGdKN6c6BZtILk5LOzGoq+AYeD9PTieciiUw6Lcd3+xXTK/W2uq
         EW2IE/Foh/h9dPaIYpYZJjn6ew50lQQzFKj7s=
Date: Sun, 24 Oct 2010 21:51:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Sundar Iyer <sundar.iyer@stericsson.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/input: ab8500-ponkey: fix error path
Message-ID: <20101025045135.GC1438@core.coreip.homeip.net>
References: <20101024170919.18cf4372@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101024170919.18cf4372@absol.kitzblitz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 05:09:19PM +0200, Nicolas Kaiser wrote:
> Looks like an obvious typo to me.
> 

Yep, it is. Applied, thank you Nicolas.

-- 
Dmitry
