Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab2DMOY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:24:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35765 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab2DMOYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:24:24 -0400
Date: Fri, 13 Apr 2012 07:24:20 -0700
From: "'Greg KH'" <gregkh@linuxfoundation.org>
To: Donald <donald@asix.com.tw>
Cc: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>,
        "'open list:USB SUBSYSTEM'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: Patch "USB: serial: mos7840: Supported MCS7810 device"
Message-ID: <20120413142420.GB3106@kroah.com>
References: <005301cd1871$87391a90$95ab4fb0$@com.tw>
 <20120412104936.65dd7683@pyramind.ukuu.org.uk>
 <002701cd191c$1077d580$31678080$@com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002701cd191c$1077d580$31678080$@com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 10:20:52AM +0800, Donald wrote:
> Hi Alan,
> 
> Thank you for your reply. As for your comment regarding the LED
> feature flag, the driver can provide a flag parameter for LED
> feature so that users will be able to set this LED feature at loading
> the driver, and by default, this flag is set false (LED
> feature is disabled). Could you let me know if this is what exactly
> matches your comment?

There should not be a "flag" a user has to set, the driver should handle
this automatically, with no need for the user to choose anything.

greg k-h
