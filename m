Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab0ITHCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 03:02:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57346 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab0ITHCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 03:02:24 -0400
Date: Mon, 20 Sep 2010 10:02:09 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: airlied@linux.ie, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: i915 regression (??)
Message-ID: <20100920070209.GA2817@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20100920062841.GA32493@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20100920062841.GA32493@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 09:28:41AM +0300, Felipe Balbi wrote:
>Hi David,
>
>I believe 2.6.36-rc4 has a regresion ? With .32 (debian sid package) I
>had everything working fine, but with .36-rc4 no output comes on LVDS,
>only on my HDMI external monitor. Here's the xrandr output:
>
>$ xrandr
>Screen 0: minimum 320 x 200, current 1280 x 1024, maximum 8192 x 8192
>(null)1 connected (normal left inverted right x axis y axis)
>	1440x900       60.0 +   40.0  VGA1 disconnected (normal left inverted 
>right x axis y axis)
>HDMI1 connected 1280x1024+0+0 (normal left inverted right x axis y axis) 376mm x 301mm
>	1280x1024      60.0*+   75.0  	1152x864       75.0  	1024x768       
>85.0     75.1     70.1     60.0  	832x624        74.6  	800x600        
>85.1     72.2     75.0     60.3
>	56.2  	640x480        85.0     72.8     75.0     66.7
>	60.0  	720x400        70.1  	640x400        70.0  DP1 disconnected 
>(normal left inverted right x axis y axis)
>HDMI2 disconnected (normal left inverted right x axis y axis)
>DP2 disconnected (normal left inverted right x axis y axis)
>
>See the first output is "(null)1" and I believe that's what's causing
>errors.

disabling kms didn't help, BTW.

-- 
balbi
