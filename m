Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab1CKRnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 12:43:39 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33909 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab1CKRnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 12:43:37 -0500
Date: Fri, 11 Mar 2011 17:43:29 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Frederick van der Wyck <fvanderwyck@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, gregkh@suse.de,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Platform: Samsung Q10 backlight driver
Message-ID: <20110311174329.GI16652@srcf.ucam.org>
References: <20110221223743.GA8548@lat.lan> <20110222052709.GA11681@core.coreip.homeip.net> <20110222212703.GA7292@lat.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222212703.GA7292@lat.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hm. This patch makes both git-am and patch very unhappy, in that they 
fail to create samsung-q10.c despite it not already existing. How did 
you generate it?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
