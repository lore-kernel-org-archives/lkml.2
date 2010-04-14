Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0DNMwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 08:52:50 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39360 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab0DNMwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 08:52:49 -0400
Date: Wed, 14 Apr 2010 13:52:44 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: add HP Compaq 2710p to 'noloop' table
Message-ID: <20100414125244.GC10075@srcf.ucam.org>
References: <alpine.LNX.2.00.1004141409450.8345@pobox.suse.cz> <20100414123643.GB9242@srcf.ucam.org> <alpine.LNX.2.00.1004141437340.8345@pobox.suse.cz> <20100414135350.3b1643c2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414135350.3b1643c2@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 01:53:50PM +0100, Alan Cox wrote:

> It's not really that unlikely that an AUX handling bug exists and only on
> one BIOS version given we've seen things as neat as i8042 emulation that
> only works on CPU #0 8)

Doubtless, but on the other hand these machines work with versions of 
Windows that were released well before them, so if there's a difference 
in behaviour then we have a bug regardless of what the spec says.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
