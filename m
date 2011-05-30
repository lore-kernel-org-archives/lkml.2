Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1E3Hyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:54:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab1E3Hyk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 03:54:40 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Arvid Brodin <arvid.brodin@enea.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: A standardized way of reporting kernel events to userspace
Date: Mon, 30 May 2011 09:56:50 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Juergen Beisert <jbe@pengutronix.de>
References: <4DE02E11.5060007@enea.com>
In-Reply-To: <4DE02E11.5060007@enea.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105300956.50446.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 28. Mai 2011, 01:04:49 schrieb Arvid Brodin:
> After I asked on linux-usb for a way for userspace to catch over-current events
> on the usb bus, it turned out that Juergen Beisert had had the need to do the
> exact same thing some time ago. He posted this patch using a uevent to notify
> userspace:

Still, I am not convinced you want to divorce reporting a problem and reacting
to it. The possible countermeasures, like reenabling a port, port reset,
cutting power or using another configuration are specific to a port or device.

	Regards
		Oliver
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
