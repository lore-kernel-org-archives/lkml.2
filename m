Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1IZS5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 14:57:35 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:45100 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab1IZS5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 14:57:34 -0400
Date: Mon, 26 Sep 2011 20:57:31 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: xen-devel@lists.xensource.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/3] xen/acpi: Domain0 acpi parser related
 platform hypercall
Message-ID: <20110926185731.GB22677@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	xen-devel@lists.xensource.com,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <cover.1317061152.git.jeremy.fitzhardinge@citrix.com>
 <3e0996798a6a113efae9e0187c5581491bdb07a7.1317061152.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3e0996798a6a113efae9e0187c5581491bdb07a7.1317061152.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 11:27:23AM -0700, Jeremy Fitzhardinge wrote:
> +#define XENPF_INTERFACE_VERSION 0x03000001

May I assume that this interface is now fixed at this value?

Bastian

-- 
It is a human characteristic to love little animals, especially if
they're attractive in some way.
		-- McCoy, "The Trouble with Tribbles", stardate 4525.6
