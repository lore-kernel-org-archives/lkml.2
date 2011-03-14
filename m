Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab1CNAHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 20:07:51 -0400
Received: from void.printf.net ([89.145.121.20]:33694 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756605Ab1CNAHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 20:07:49 -0400
From: Chris Ball <cjb@laptop.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] viafb: kill lcd_panel_id
References: <1299964979-3391-1-git-send-email-FlorianSchandinat@gmx.de>
	<1299964979-3391-2-git-send-email-FlorianSchandinat@gmx.de>
	<m3hbb7xaup.fsf@pullcord.laptop.org> <4D7CFBC7.2060109@gmx.de>
Date: Sun, 13 Mar 2011 20:05:13 -0400
In-Reply-To: <4D7CFBC7.2060109@gmx.de> (Florian Tobias Schandinat's message of
	"Sun, 13 Mar 2011 18:15:51 +0100")
Message-ID: <m3zkoywoqu.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On Sun, Mar 13 2011, Florian Tobias Schandinat wrote:
> No need to worry. The external interface is kept for compatibility,
> only the internal uses are replace by panel hres/vres which contain
> the same information but are more generic.
>
> I have not yet tested it on OLPC as I did not have the time to compile
> a new kernel for it, but as it works on my VX900 laptop which also
> uses the viafb_lcd_panel_id setting it should be fine.

Thanks, this makes sense; the patch looks fine, then.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
