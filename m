Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab1EKQ6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:58:51 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41909 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab1EKQ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:58:50 -0400
Date: Wed, 11 May 2011 14:02:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, alan@linux.intel.com, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Add option to disable LVDS
Message-ID: <20110511130258.GA29435@srcf.ucam.org>
References: <20110510212038.GA3279@patrik-macbook>
 <20110510224602.73b24d0a@lxorguk.ukuu.org.uk>
 <BANLkTikz+PrQY2egkPTiacDSH5-Gkqkbww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikz+PrQY2egkPTiacDSH5-Gkqkbww@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 01:18:07AM +0200, Patrik Jakobsson wrote:

> I agree, it's not a good way to handle it, but since I haven't been
> able to pinpoint the problem (and this is staging) it's something that
> works for now. Perhaps a nicer way to get around it is by checking
> against the dmi system id. That way it would be transparent to the
> user. But you might prefer we fix the real problem instead of hacking
> around it.

Assuming the VBT data is anything like 915, it should be possible to 
parse LVDS presence that way.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
