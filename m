Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab2FVTEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 15:04:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44234 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab2FVTEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 15:04:08 -0400
Message-ID: <4FE4C1A3.4080804@suse.cz>
Date: Fri, 22 Jun 2012 21:04:03 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120610 Thunderbird/15.0a2
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org, lwn@lwn.net,
        Willy Tarreau <w@1wt.eu>, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Linux 2.6.32.55
References: <20120125223434.GA31647@kroah.com>
In-Reply-To: <20120125223434.GA31647@kroah.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2012 11:34 PM, Greg KH wrote:
> I'm announcing the release of the 2.6.32.55 kernel.
...
> Bjorn Helgaas (1): PNP: work around Dell 1536/1546 BIOS MMCONFIG
> bug that breaks USB

Hi, this one is dependant on 24d25dbfa63c3 (x86/PCI: amd: factor out
MMCONFIG discovery), otherwise amd_get_mmconfig_range is undefined...

regards,
-- 
js
suse labs
