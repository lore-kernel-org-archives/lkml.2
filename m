Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab0JTGgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:36:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52087 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758036Ab0JTGgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:36:06 -0400
Date: Wed, 20 Oct 2010 09:35:38 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Felipe Balbi <me@felipebalbi.com>, "Balbi, Felipe" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
Message-ID: <20101020063538.GG15448@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20101019103234.GI31170@legolas.emea.dhcp.ti.com>
 <AANLkTinXzMQXoyyu+anSCvSuE9w3FWAP5HswDS0kfpzE@mail.gmail.com>
 <20101019111613.GJ31170@legolas.emea.dhcp.ti.com>
 <AANLkTikkMphKa2DGGtWxy-3LpFX0kn92UEYPj==Euzok@mail.gmail.com>
 <20101019115236.GL31170@legolas.emea.dhcp.ti.com>
 <AANLkTim3NsgjC3Nh8VCCrx4cV1Y+kn38=30=en0KCft6@mail.gmail.com>
 <6ea089ac75d4d15d88698468eacb7fe3@secure211.sgcpanel.com>
 <AANLkTinYM5aavk9_jcTTymff=OY+Yyv8T6C+dmMih0p_@mail.gmail.com>
 <20101019234414.GB30991@atomide.com>
 <87fww1u3fw.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87fww1u3fw.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 19, 2010 at 07:13:07PM -0500, Kevin Hilman wrote:
>One thing I don't like about this is that there is currently no way to
>'select' as a module.

Yeah, I remember suggesting to add "module" to Kconfig language which
would do the job of selecting as module.

-- 
balbi
