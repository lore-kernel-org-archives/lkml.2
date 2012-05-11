Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2EKFOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 01:14:16 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:53915 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753721Ab2EKFOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 01:14:15 -0400
Message-ID: <1336712810.12189.146.camel@cumari.coelho.fi>
Subject: Re: [PATCH] wlcore: wlcore should depend on MAC80211
From: Luciano Coelho <coelho@ti.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 11 May 2012 08:06:50 +0300
In-Reply-To: <1336711194-26883-1-git-send-email-levinsasha928@gmail.com>
References: <1336711194-26883-1-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 06:39 +0200, Sasha Levin wrote:
> wlcore can't be built if MAC80211 isn't set.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---

Thanks for your patch, Sasha! But this change was already submitted and
has been applied in the wl12xx.git tree.  I've sent a pull request with
it already, but it hasn't been pulled into wireless-next and up.

http://www.spinics.net/lists/linux-next/msg19910.html
http://www.spinics.net/lists/linux-wireless/msg89583.html

-- 
Cheers,
Luca.

