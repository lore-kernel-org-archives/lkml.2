Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0FHNTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 09:19:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:22014 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab0FHNTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 09:19:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kg79jjdsKTxa/oHwa6IgzOs3K/ru3BsHtzIgf5XFDaSYFf+6ZZrUC54IXtJm8RGHWu
         6uivc1UbMSLQ3TqL+U/Fqm/5ki1btxcDjkmvdcAA3dBZF95wKzcrhwZ8f4TTGXO9QMTm
         H3DCVUN345amX12V40u2kdg7FhweRA91TLiXM=
Subject: Re: BUG: double spinlock in "drivers/net/3c505.c"
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Alexander Strakh <strakh@ispras.ru>
Cc: Philip Blundell <philb@gnu.org>,
       Craig Southeren <craigs@ineluki.apana.org.au>,
       Andrew Tridgell <tridge@web.rsise.anu.edu.au>,
       Alan Cox <Alan.Cox@linux.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <201006071517.28744.strakh@ispras.ru>
References: <201006071517.28744.strakh@ispras.ru>
Content-Type: text/plain
Date: Tue, 08 Jun 2010 15:26:45 +0200
Message-Id: <1276003605.3916.14.camel@lovely>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 15:17 +0400, Alexander Strakh wrote: 
> 	KERNEL_VERSION: 2.6.35-rc1
>         SUBJECT: duble spinlock  in function elp_start_xmit

Not only in elp_start_xmit. This driver is for a pretty old and slow isa
ethernet card and I think nobody cares. To quote a comment from the
source: "[...] the concurrency protection is particularly awful".

Thanks, 
   Christoph


