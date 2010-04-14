Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab0DNNn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 09:43:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59309 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab0DNNn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 09:43:27 -0400
Date: Wed, 14 Apr 2010 14:43:21 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: add HP Compaq 2710p to 'noloop' table
Message-ID: <20100414134321.GA11335@srcf.ucam.org>
References: <alpine.LNX.2.00.1004141409450.8345@pobox.suse.cz> <20100414123643.GB9242@srcf.ucam.org> <alpine.LNX.2.00.1004141437340.8345@pobox.suse.cz> <20100414135350.3b1643c2@lxorguk.ukuu.org.uk> <20100414125244.GC10075@srcf.ucam.org> <20100414143550.75def636@lxorguk.ukuu.org.uk> <20100414133801.GA11142@srcf.ucam.org> <alpine.LNX.2.00.1004141538490.8345@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1004141538490.8345@pobox.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 03:40:14PM +0200, Jiri Kosina wrote:

> Ask vendors, who are shipping specialized windows drivers for their mice, 
> to be please so kind and always include a linux driver as well, and nuke 
> all the probing logic from in-kernel driver?

Well, in this case we know that there's a synaptics (it's in ACPIPNP) 
and we know that an internal synaptics places pretty heavy constraints 
on what else is going to be attached to the machine.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
