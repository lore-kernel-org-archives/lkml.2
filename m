Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab1CMQKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 12:10:21 -0400
Received: from void.printf.net ([89.145.121.20]:40511 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab1CMQKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 12:10:19 -0400
From: Chris Ball <cjb@laptop.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] viafb: kill lcd_panel_id
References: <1299964979-3391-1-git-send-email-FlorianSchandinat@gmx.de>
	<1299964979-3391-2-git-send-email-FlorianSchandinat@gmx.de>
Date: Sun, 13 Mar 2011 12:07:42 -0400
In-Reply-To: <1299964979-3391-2-git-send-email-FlorianSchandinat@gmx.de>
	(Florian Tobias Schandinat's message of "Sat, 12 Mar 2011 21:22:56
	+0000")
Message-ID: <m3hbb7xaup.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On Sat, Mar 12 2011, Florian Tobias Schandinat wrote:
> This patch removes all internal uses of another mostly artificial
> value. It does duplicate the information of the maximum resolution and
> it is not flexible as only a few resolutions exist. Hence it is better
> to remove it and clean the mess up.
> No runtime change expected.
>
> Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

We're passing viafb_lcd_panel_id at boot-time on OLPC XO-1.5.
Won't this break boot for us, and anyone else who needs to use it?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
