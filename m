Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab2IMRfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:35:07 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:53454 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2IMRfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:35:04 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiqWAEQYUlBV5h1yPGdsb2JhbABFhR4jhQCwOAICehkBAQEBNzSCIAEBBTocIxAIAxguFCUKGogku3EUinw0gS6DdWADlV+FcINGiVQ
X-IronPort-AV: E=Sophos;i="4.80,417,1344204000"; 
   d="scan'208";a="114954273"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 13 Sep 2012 19:41:08 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-input@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: input_to_handler: unable to handle kernel NULL pointer
 dereference
Message-ID: <20120913174108.GA3099@polaris.bitmath.org>
References: <5051F648.8030003@suse.cz>
 <20120913155738.GA3519@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913155738.GA3519@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 08:57:38AM -0700, Dmitry Torokhov wrote:
> On Thu, Sep 13, 2012 at 05:05:44PM +0200, Jiri Slaby wrote:
> > Hi,
> > 
> > -next commit "Input: Send events one packet at a time" seems like broke
> > the input layer:
> 
> Right, Henrik has a patch for this.

Yep, it just missed the cut for today, but will appear in tomorrow's
-next.

Thanks,
Henrik
