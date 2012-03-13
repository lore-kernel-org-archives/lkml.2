Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab2CMNJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:09:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55985 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2CMNJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:09:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v8 0/4] USB: OHCI-HCD: Support for LPC32xx
Date: Tue, 13 Mar 2012 13:09:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org
References: <1331589292-18986-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1331589292-18986-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203131309.21529.arnd@arndb.de>
X-Provags-ID: V02:K0:veAbDlxTrE1GSpY+ZhYML8YTYBHjWz+QglCqCQ262VM
 zE5YnwiKYbxaJrHRlpbFyNU9Ac+ZsOgahrTRADdkFtElIKL8MA
 uFBwSEKkc3wT8IBcMWhv9in0tZ90+Ihrg8nZZASwb9HGfnYPty
 j+fBQeYEiKg5LE6SXBcrE1Tlg6iEQwTanz1WWPeRyqitotcU1Y
 +jNUPnkX87AStTFKB3f4nuQf6tPyfwJ9Vrncp9zi5ljIG7/g3X
 WdH56wKJkms+Q/OcD89yBhVyF2PWdrIQ+wWNHFZn/VCNDxyPbv
 0XlYsx3Sw+WyniNQZpXz+MQ3u9+KaP51a10MTGGBhq2waCFemC
 5qWtNxy4akzdWfGLVa/A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2012, Roland Stigge wrote:
> These patches add support for the LPC32xx to the ohci-pnx4008 driver and make
> the driver use smbus functions.
> 
> As discussed with Greg-KH on the USB mailing list, the ohci-pnx4008 driver is
> first renamed to reflect its multi-platform support. The second patch also
> renames the respective pnx4008_* symbols accordingly.
> 
> The third patch adds the actual lpc32xx support.
> 
> The fourth patch removes the re-coded i2c_write() by using an existing smbus
> function. You can leave out this very single patch to still have the desired
> LPC32xx support. It just fixes existing kernel code to only use smbus calls in
> this driver.
> 
> Applies to v3.3-rc7
> 
> Changes since v7:
> 
> * Removed pnx4008 filename reference
> * Rename via git format-patch -M
> 
> Thanks to Arnd Bergmann and Wolfram Sang for reviewing!
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
