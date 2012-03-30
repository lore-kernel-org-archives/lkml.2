Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760768Ab2C3M1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:27:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51123 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760581Ab2C3M1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:27:45 -0400
Date: Fri, 30 Mar 2012 14:27:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <greg@kroah.com>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>,
        Anatolij Gustschin <agust@denx.de>
Subject: Re: menuconfig looks funny since recently, i.e. USB gains on
 importance :)
Message-ID: <20120330122750.GB27427@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jiri Kosina <jkosina@suse.cz>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <greg@kroah.com>, linux-usb@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	David Daney <david.daney@cavium.com>,
	Anatolij Gustschin <agust@denx.de>
References: <20120330100056.GA27427@x1.osrc.amd.com>
 <alpine.LRH.2.00.1203301328330.22234@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1203301328330.22234@twin.jikos.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 01:28:55PM +0200, Jiri Kosina wrote:
> Caued by 53c6bc24fdc, adding David Daney.

Thanks to all for the swift help, fixed by
http://marc.info/?l=linux-kernel&m=133245014825438&w=2

-- 
Regards/Gruss,
Boris.
