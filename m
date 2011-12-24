Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab1LXOUd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 09:20:33 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46953 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab1LXOUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 09:20:32 -0500
Date: Sat, 24 Dec 2011 14:20:28 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrzej Prochyra <andrzej@prochyra.name>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Platform: samsung-laptop: add DMI information for
 Samsung N150 Plus
Message-ID: <20111224142028.GA32171@srcf.ucam.org>
References: <87ty4ss0z4.fsf@prochyra.name>
 <CAHR064h7a=RQq=p1J+gKpC5_6ow8ChUFFkC39HwtmerHaMksjw@mail.gmail.com>
 <87ty4qdpna.fsf@prochyra.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ty4qdpna.fsf@prochyra.name>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 24, 2011 at 02:12:57PM +0000, Andrzej Prochyra wrote:
> 'acpi_video0' not functional.  Brightness can be controlled through
> intel_backlight interface.  There are 21 brightness levels and the
> backlight can be turned off.

If acpi_video0 doesn't work then we either need to work out why it's not 
working or make it vanish completely, so this patch isn't the correct 
approach.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
