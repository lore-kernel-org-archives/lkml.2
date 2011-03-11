Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab1CKGij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 01:38:39 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:46607 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278Ab1CKGig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 01:38:36 -0500
Message-ID: <4D79C3AC.7090900@metafoo.de>
Date: Fri, 11 Mar 2011 07:39:40 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: linux-next: manual merge of the usb tree with the s5p tree
References: <20110311170912.0fb48cf4.sfr@canb.auug.org.au>
In-Reply-To: <20110311170912.0fb48cf4.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 07:09 AM, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> arch/arm/mach-s3c2440/mach-gta02.c between commit 326d05c15f7f ("ARM:
> S3C2440: Request usb pullup pin before using it on GTA02") from the s5p
> tree and commit e27c3c5c7e0f ("ARM: s3c24xx: Switch to common GPIO
> controlled UDC pullup implementation") from the usb tree.
> 
> The latter commit removes the function gta02_udc_command() which is
> modified by the former.  I removed the function.
> 

Hi

Kukjin could you drop 326d05c15f7f ("ARM: S3C2440: Request usb pullup pin
before using it on GTA02") from your tree? It has been superseded by the other
commit in Gregs tree.

- Lars
