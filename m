Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3ABRnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 12:43:31 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33923 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab3ABRn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 12:43:28 -0500
Date: Wed, 2 Jan 2013 17:43:19 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Shea Levy <shea@shealevy.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Revisiting EFI boot stub config file support
Message-ID: <20130102174319.GA2590@srcf.ucam.org>
References: <50E306FB.6080607@shealevy.com>
 <50E31BB4.7040702@zytor.com>
 <710F73BE-9F65-48C9-8739-BFCF097F4B07@shealevy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <710F73BE-9F65-48C9-8739-BFCF097F4B07@shealevy.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 08:26:29AM -0500, Shea Levy wrote:

> Hm, ok. Does the boot stub have access to CONFIG_CMDLINE? Or could 
> another compile-time setting be added so that distros can ship livecds 
> that automatically use a config file found at a hard-coded location?

Just pass the config file as the first argument?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
