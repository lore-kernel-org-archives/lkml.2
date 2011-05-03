Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab1ECSto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 14:49:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:59605 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251Ab1ECStm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 14:49:42 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/2] usbnet: Convert dbg to dev_dbg and neatening
Date: Tue, 3 May 2011 20:51:16 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1304445019.git.joe@perches.com> <f86364fbdc335fadad003081d010843579e95765.1304445019.git.joe@perches.com>
In-Reply-To: <f86364fbdc335fadad003081d010843579e95765.1304445019.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105032051.17025.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Mai 2011, 20:17:58 schrieb Joe Perches:
> Use the more standard logging form.
> Add a bit more tidying style.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Please do not mix changes like that. Either only coding style or only
other cleanups.

	Regards
		Oliver

-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
