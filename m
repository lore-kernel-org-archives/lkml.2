Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab0KWJQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 04:16:41 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:37480 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736Ab0KWJQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 04:16:39 -0500
Date: Tue, 23 Nov 2010 11:16:46 +0200
From: Felipe Balbi <balbi@ti.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: "Balbi, Felipe" <balbi@ti.com>, "airlied@linux.ie" <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: i915 regression (??)
Message-ID: <20101123091646.GA2308@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20100920062841.GA32493@legolas.emea.dhcp.ti.com>
 <8u3s94$giian9@orsmga002.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8u3s94$giian9@orsmga002.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 01:08:02PM -0500, Chris Wilson wrote:
>On Mon, 20 Sep 2010 09:28:42 +0300, Felipe Balbi <balbi@ti.com> wrote:
>> I believe 2.6.36-rc4 has a regresion ? With .32 (debian sid package) I
>> had everything working fine, but with .36-rc4 no output comes on LVDS,
>> only on my HDMI external monitor. Here's the xrandr output:
>
>You don't have LVDS, but eDP. We are working on getting the power-on
>sequence correct for all systems but alas we still in the phase where we
>fix it for some machines and cause others to fail.

.37-rc3 and it's still broken. Any ways I could help ? I have at least a
machine to test (Dell e6410). It works sometimes out of luck and others,
only rebooting.

-- 
balbi
