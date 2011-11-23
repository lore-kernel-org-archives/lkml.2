Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab1KWL27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:28:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab1KWL25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:28:57 -0500
Date: Wed, 23 Nov 2011 12:28:55 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [PATCH 6/8] HID-multitouch: Add egalax ID for Acer Iconia W500
In-Reply-To: <1322042074-3759-7-git-send-email-benjamin.tissoires@enac.fr>
Message-ID: <alpine.LNX.2.00.1111231228260.28728@pobox.suse.cz>
References: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr> <1322042074-3759-7-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011, Benjamin Tissoires wrote:

> From: Marek Vasut <marek.vasut@gmail.com>
> 
> This patch adds USB ID for the touchpanel in Acer Iconia W500. The panel
> supports up to five fingers, therefore the need for a new addition of panel
> types.
> 
> originally Signed-off-by: Marek Vasut <marek.vasut@gmail.com>

Before taking this, I'd like to have the credits / signoffs for this patch 
clarified.

Thanks,

-- 
Jiri Kosina
SUSE Labs
