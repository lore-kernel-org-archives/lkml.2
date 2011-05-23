Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab1EWUum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:50:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52647 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab1EWUuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:50:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=YnJkBwu5N7QP1EtuGBgr0zVKWMq+3NkB4Psw7safHvbIyFNGsWuEfbyN6OYhHzdjWJ
         v9Swi02WMfuZXoxf6O4A80wD+ZddR4d/Q1V3kT415hNxkefkWeCCS7C7+/6QPdlp2DDo
         zW31sVdDHc9iByTCbn4Eu0y6tb2rRsr1jR+Tc=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: simon@mungewell.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        OliverNeukumoliver@neukum.org
Subject: Re: [PATCH] input: Add Nintendo extension controller driver
References: <20110516214608.17011.3075.stgit@ponder>
Date: Mon, 23 May 2011 22:50:34 +0200
In-Reply-To: <20110516214608.17011.3075.stgit@ponder> (Grant Likely's message
	of "Mon, 16 May 2011 15:46:08 -0600")
Message-ID: <87fwo5ywdh.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Grant" == Grant Likely <grant.likely@secretlab.ca> writes:

 Grant> This driver adds support for Nintendo Wiimote extension controllers
 Grant> directly attached to an i2c bus, such as when using an adaptor like
 Grant> the Wiichuck.


 Grant> + * If the device is recognized, then the polling period is bumped up
 Grant> + * to 50ms, and the state machine enters into a loop alternating

<snip>

 Grant> +#else
 Grant> +#define WIICHUCK_CAPTURE_PERIOD (100)	/* 100 milliseconds */

50 or 100ms?

-- 
Bye, Peter Korsgaard
