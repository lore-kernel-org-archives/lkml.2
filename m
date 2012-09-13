Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2IMP5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:57:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52185 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758220Ab2IMP5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:57:53 -0400
Date: Thu, 13 Sep 2012 08:57:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-input@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: input_to_handler: unable to handle kernel NULL pointer
 dereference
Message-ID: <20120913155738.GA3519@core.coreip.homeip.net>
References: <5051F648.8030003@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5051F648.8030003@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 05:05:44PM +0200, Jiri Slaby wrote:
> Hi,
> 
> -next commit "Input: Send events one packet at a time" seems like broke
> the input layer:

Right, Henrik has a patch for this.

Thanks.

-- 
Dmitry
