Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935719Ab1ETMEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 08:04:41 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:41117 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935666Ab1ETMEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 08:04:39 -0400
Subject: Re: [RFC/PATCH 05/13] net: wl12xx: remove the nops
From: Luciano Coelho <coelho@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1305321990-22041-6-git-send-email-balbi@ti.com>
References: <1305321990-22041-1-git-send-email-balbi@ti.com>
	 <1305321990-22041-6-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 15:04:33 +0300
Message-ID: <1305893073.12586.1667.camel@cumari>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-14 at 00:26 +0300, Felipe Balbi wrote:
> Nops aren't needed. When we actually need
> those calls, then we add them with meat
> and barbecue sauce.
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---

Applied the parts that are still relevant (some of the calls already
have saucy beef in them ;).

-- 
Cheers,
Luca.

