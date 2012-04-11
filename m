Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab2DKLIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:08:32 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57964 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab2DKLIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:08:30 -0400
Date: Wed, 11 Apr 2012 13:08:26 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Donald <donald@asix.com.tw>
Cc: "'Greg KH'" <gregkh@linuxfoundation.org>,
        "'open list:USB SUBSYSTEM'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: Patch "USB: serial: mos7840: Supported MCS7810 device"
Message-ID: <20120411110826.GA22200@localhost>
References: <009c01cd00ee$924eb2e0$b6ec18a0$@com.tw>
 <20120313160951.GA18810@kroah.com>
 <005a01cd0db0$8ec89e50$ac59daf0$@com.tw>
 <20120329151343.GA32474@kroah.com>
 <006401cd17c6$157ba2c0$4072e840$@com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <006401cd17c6$157ba2c0$4072e840$@com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 05:32:53PM +0800, Donald wrote:
> Hi Greg,
> 
> I am re-submitting this patch that supports MCS7810 device for the mos7840
> driver. This patch was created against 3.4-rc1 and has been verified on
> 3.4-rc1 also. If you see any problem regarding this patch, please let me
> know at any time. Thank you for your help.
> 
> Besides, I found two things regarding 3.4-rc, firstly, it added a macro to
> replace module_init() and module_exit(); secondly, the system will crash if
> I remove module before unplug the dongle; while this issue doesn't happen on
> Linux kernel 3.2.9. I had been tested mcs7840 and prolific-pl2303, both
> drivers have the same scenario. I am not sure if this issue is relating to
> the macro added in 3.4-rc and would like to know if you have any comment on
> this issue.

This is a known issue which has been fixed by the following patch:

	http://marc.info/?l=linux-usb&m=133296552518354&w=2

It should show up in 3.4-rc shortly.

Thanks,
Johan
