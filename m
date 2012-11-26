Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab2KZOou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 09:44:50 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:34300 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab2KZOot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 09:44:49 -0500
Date: Mon, 26 Nov 2012 06:46:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ortwin =?iso-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] HID: hid-input: battery quirk for Apple keyboard
Message-ID: <20121126144614.GA6659@kroah.com>
References: <50B36147.4070602@odi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50B36147.4070602@odi.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 01:32:07PM +0100, Ortwin Glück wrote:
> Support battery capacity on another Apple wireless
> keyboard.
> 
> NB: most likely all other APPLE_ALU_WIRELESS_*
> keyboards should be added as well.
> 
> Cc: stable <at> kernel.org
> Signed-off-by: Ortwin Glück <odi@odi.ch>
> ---

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
