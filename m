Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab1C1WOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 18:14:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40680 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab1C1WN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 18:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Zh2sL34vQQqaG90r+wTa5Av3suGw2LQTsr04RcQgq3KS1X8uZOK3VQI9tyeEhpMDip
         bdBtyVLFLHegbs6x2j3+PwrunmogxLaj34aqDC6hdSnqFdrx0NzBH/oPJDgQ8m2gu0pA
         l0kwumi0KpFzDwm/gNsBRlspf3yhCmWWQHV8g=
Date: Mon, 28 Mar 2011 23:14:13 +0100
From: Frederick van der Wyck <fvanderwyck@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Platform: Samsung Q10 backlight driver
Message-ID: <20110328221413.GA7620@ntl>
References: <20110221223743.GA8548@lat.lan>
 <20110222052709.GA11681@core.coreip.homeip.net>
 <20110222212703.GA7292@lat.lan>
 <20110311174329.GI16652@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311174329.GI16652@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Fri, Mar 11, 2011 at 05:43:29PM +0000, Matthew Garrett wrote:
> Hm. This patch makes both git-am and patch very unhappy, in that they 
> fail to create samsung-q10.c despite it not already existing. How did 
> you generate it?

Did you get the chance to try applying the new copy of the Samsung
Q10 patch I sent in response to your message above? I guess you're
waiting to do it along with the next round of patches, but please
let me know if you tried and it still caused problems, so I can
fix it for next time.

Thanks,
Frederick
