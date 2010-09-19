Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0ISXdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 19:33:00 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61028 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab0ISXc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 19:32:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KnKd0ZXesr0zUi6SKttRPDJPSkjP2wTg+lpju7vuQDv8Ta5HI8N5AGtYRUu/OXV07W
         osoSAC6/gJRNCksTbK6UffE0F1dMV6b5fINrShEkfYEvEFGZmbw+TZlgBXRp+7hYbgIx
         AhSjVIvC3uX6cu4V3xranRuX0+WtmSE9c7/jE=
Date: Sun, 19 Sep 2010 16:32:53 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: uinput: Setup MT usage during device creation
Message-ID: <20100919233252.GC6565@core.coreip.homeip.net>
References: <1284897253-1634-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284897253-1634-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 01:54:13PM +0200, Henrik Rydberg wrote:
> The input devices created by uinput do not currently handle multitouch
> properly. All events will appear as if they came from slot zero, and
> the input event buffers are not adjusted. This patch creates the MT
> slots during setup, and sets the number of events per packet based
> on the MT usage.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Applied to 'for-linus', thank you Henrik.

-- 
Dmitry
