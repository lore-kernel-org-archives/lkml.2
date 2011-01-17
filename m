Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab1AQWmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 17:42:45 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19765 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab1AQWmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 17:42:43 -0500
Date: Mon, 17 Jan 2011 23:42:45 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Nico Schottelius <nico-kernel-20110117@schottelius.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.37-05761-gf878133: Intel (i915) renders incorrectly
In-Reply-To: <20110117222824.GA20444@schottelius.org>
Message-ID: <alpine.LNX.2.00.1101172341410.27021@swampdragon.chaosbits.net>
References: <20110117222824.GA20444@schottelius.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jan 2011, Nico Schottelius wrote:
> Hey!
> 
> After several suspend/resume cycles, the display is completly
> screwed up, only parts are shown and rendering is slow.
> 
> Attached are xorg.log and dmesg part.
> 
> Not sure anymore, whether LKML is the right destination
> or some freedesktop-ml?

If it works with older kernel but not with newer, then lkml should 
certainly be included in CC at least.


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

