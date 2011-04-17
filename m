Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1DQJTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 05:19:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48165 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1DQJTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 05:19:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=FwD7BopLFnc8E+TmD6p2C01E3D+ClySBSGNU9IACbK9sj2Ox9M2lPf2NISPtuWvaXd
         tuJcEeeBoQ9Xziz/DU0zuHKoHDEWQ2jE0R13dNENy4HKpki1aJjOjD6Uilqyj6SQ+vWQ
         N0f8Y7PaEw2ZiSvyg4MwPexKEDyymgFHpC9BY=
Date: Sun, 17 Apr 2011 17:19:21 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        trivial@kernel.org, lrg@slimlogic.co.uk
Subject: Re: [PATCH] drivers:regulator:change debug statement be consistent
 with the style of the rest.
Message-ID: <20110417091918.GA3509@gmail.com>
Mail-Followup-To: Wanlong Gao <wanlong.gao@gmail.com>,
	broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
	trivial@kernel.org, lrg@slimlogic.co.uk
References: <1302968543-3150-1-git-send-email-wanlong.gao@gmail.com>
 <20110416175440.GD25811@opensource.wolfsonmicro.com>
 <4DAA3A25.30501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAA3A25.30501@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 08:53:57AM +0800, Wanlong Gao wrote:
> 
> 
> change the "mc13783_regulator_probe" string in the function
> "mc13783_regulator_probe"
> to "__func__" for the debug statement be consistent with the style
> of the rest of
> the file.
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Hi Wanlong,
	I really wanna know have Mark given this patch a 'Acked-by'.
Because you are the first one, who sent this patch. Of course, Mark
maybe your workmate or else.
	I am so sorry for this silly question :) but i am curious 
about it.

Thanks.
Harry Wei.
