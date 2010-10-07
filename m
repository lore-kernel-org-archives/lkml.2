Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145Ab0JGHyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 03:54:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45296 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756025Ab0JGHyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 03:54:44 -0400
Date: Thu, 7 Oct 2010 10:54:25 +0300
From: Felipe Balbi <balbi@ti.com>
To: matt mooney <mfm@muteddisk.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, David Vrabel <david.vrabel@csr.com>,
        Peter Korsgaard <jacmet@sunsite.dk>, "Balbi, Felipe" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "usb-storage@lists.one-eyed-alien.net" 
	<usb-storage@lists.one-eyed-alien.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] usb: makefile cleanup
Message-ID: <20101007075425.GH686@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1286417006-32510-1-git-send-email-mfm@muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1286417006-32510-1-git-send-email-mfm@muteddisk.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 06, 2010 at 09:03:26PM -0500, matt mooney wrote:
>For all modules, change <module>-objs to <module>-y; remove
>if-statements and replace with lists using the kbuild idiom; move
>flags to the top of the file; and fix alignment while trying to
>maintain the original scheme in each file.
>
>None of the dependencies are modified.
>
>Signed-off-by: matt mooney <mfm@muteddisk.com>
>Acked-by: Sam Ravnborg <sam@ravnborg.org>

for musb parts:

Acked-by: Felipe Balbi <balbi@ti.com>

-- 
balbi
