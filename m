Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab0EQO5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:57:13 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:41100 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595Ab0EQO5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:57:11 -0400
Subject: Re: [PATCH 1/1] regulator: return set_mode is same mode is
 requested
From: Sundar R Iyer <sundar.iyer@stericsson.com>
Reply-To: <sundar.iyer@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Linus WALLEIJ <linus.walleij@stericsson.com>
In-Reply-To: <20100517144411.GD5257@opensource.wolfsonmicro.com>
References: <1274105393-32197-1-git-send-email-sundar.iyer@stericsson.com>
	 <20100517144411.GD5257@opensource.wolfsonmicro.com>
Content-Type: text/plain
Organization: STEricsson
Date: Mon, 17 May 2010 20:26:54 +0530
Message-ID: <1274108214.20589.28.camel@bnru01>
MIME-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 16:44 +0200, Mark Brown wrote:
> The commit message reads "regulator: return set_mode is same mode is
> requested".  I'm having a hard time parsing what that actually means,
> you probably need a "when" in there...
> 
Oops. My bad. I messed by typoing up the commit message.

> This is going to oops if the regulator doesn't implement a get_mode()
> operation.  
Okay. I will add a sanity check for that.

> I'm also a little ambivalent on the benefit of it - if the goal is to
> save I/O costs (you didn't say...) it's not clear to me that the effort
> of checking the current mode is going to be a win in situations where
> the mode is actually being changed a lot.
Okay. I came up across this and hence the change. This is intended when
the same mode is requested! I will edit the commit message appropriately.

> 
> As I said in reply to your previous message the trend is away from
> having any mode configration at all, with regulators being able to adapt
> to their current load without any software assistance.
I posted this as this is currently supported in the tree.

Thanx for the prompt review and reply,

Regards,
Sundar


