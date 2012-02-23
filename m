Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab2BWRC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:02:58 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39106 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab2BWRC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:02:56 -0500
Date: Thu, 23 Feb 2012 17:02:33 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable <stable@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        "jirisl >> Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: Lost ps/2 input in 3.2.5 (aka PCI: Rework ASPM disable code)
Message-ID: <20120223170233.GA4328@srcf.ucam.org>
References: <4F4540E6.2020708@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4540E6.2020708@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, bother. Can you give lspci -vvv before and after the patch, along 
with dmesg?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
