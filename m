Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab0DFQwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:52:55 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:53634 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078Ab0DFQwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:52:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JZNVuDmEXYUuaHeK+AmX17VPcVDcGJD1/uvFU2fPzWYrbibSk6xdUh27mdPtJ8uZ9O
         P++DOe3ZJCtYvdHKCGQHIQtIMghwOVWSmKajTFW3dX1e+S1TZTD5TP1bzxEnQ/nadsBt
         IEMfgxq78lWl51eIDyIcaN4tsrY/Omufww/2k=
Date: Tue, 6 Apr 2010 20:52:37 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: Use genirq in wm831x_power
Message-ID: <20100406165237.GA29083@oksana.dev.rtsoft.ru>
References: <1268245660-19140-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1268245660-19140-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 06:27:40PM +0000, Mark Brown wrote:
> Since the WM831x core has been converted to use genirq for the
> interrupt controller there is no longer any need for chip specific
> wrappers for IRQ operations. Convert to use genirq directly.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied, thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
