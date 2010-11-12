Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab0KLD5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 22:57:38 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54157 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab0KLD5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 22:57:37 -0500
Date: Fri, 12 Nov 2010 03:57:32 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Norbert Preining <preining@logic.at>
Cc: Mattia Dongili <malattia@linux.it>, linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101112035732.GB7574@srcf.ucam.org>
References: <20101104142915.GC7650@gamma.logic.tuwien.ac.at> <20101110035833.GB3029@kamineko.org> <20101111235000.GA6651@gamma.logic.tuwien.ac.at> <20101112034423.GA7407@srcf.ucam.org> <20101112035027.GD26742@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101112035027.GD26742@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 12:50:27PM +0900, Norbert Preining wrote:
> THen the problem is simply that the acpi events are not coming through
> when pressing the respective keys.

Then yes, that's probably related to sony-laptop. If you run evtest 
against the /dev/input/event device that corresponds to sony-laptop, 
what events do you get when you hit the brightness keys?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
