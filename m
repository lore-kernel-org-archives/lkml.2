Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1CAMfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 07:35:31 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51462 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab1CAMfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 07:35:30 -0500
Date: Tue, 1 Mar 2011 12:35:20 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Pedro Ribeiro <pedrib@gmail.com>, ibm-acpi-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: ThinkPad T400 : should kernel option "reboot=pci" be hard
	coded ?
Message-ID: <20110301123520.GA30115@srcf.ucam.org>
References: <201006071122.21925.toralf.foerster@gmx.de> <201006091343.48924.toralf.foerster@gmx.de> <AANLkTimkWN5tU88J-M3Q4aq9pq-WljyyPAUPfnf9cuhf@mail.gmail.com> <201103010940.13647.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201103010940.13647.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 09:40:13AM +0100, Toralf Förster wrote:
> I'd like to point to this after a half year of lthe last email. Shouldn't it 
> be hard coded ?

Windows appears to have exactly the same behaviour, so it seems that 
this is working like designed.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
