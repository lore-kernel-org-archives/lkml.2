Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab2A3XKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:10:15 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:45946 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754128Ab2A3XJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:09:59 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 11/16] ath5k: make ath5k_modparam_no_hw_rfkill_switch real
Date: Tue, 31 Jan 2012 00:09:04 +0100
User-Agent: KMail/1.9.10
Cc: ath5k-devel@venema.h4ckr.net, Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Bob Copeland <me@bobcopeland.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de> <1327960820-11867-12-git-send-email-danny.kukawka@bisect.de> <4F2715A7.9030101@gmail.com>
In-Reply-To: <4F2715A7.9030101@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201201310009.06012.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327964999;17bd6e6f;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Montag, 30. Januar 2012, Jiri Slaby wrote:
> On 01/30/2012 11:00 PM, Danny Kukawka wrote:
> > Make ath5k_modparam_no_hw_rfkill_switch real bool to fix:
> > 'warning: return from incompatible pointer type' compiler warning.
>
> Hi, I'm afraid you are too late:
> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;
>h=11deb53328a06ad4edbf774f5c3b61c6dbb9104c

Hi,

no problem. I didn't check against linux-next.

Danny
