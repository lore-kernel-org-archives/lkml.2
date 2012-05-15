Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901Ab2EONcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:32:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab2EONcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:32:47 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 3.4.0-rc7 regression: bluetooth vs. s2ram
Date: Tue, 15 May 2012 15:29:01 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com
References: <20120515131453.GA1936@elf.ucw.cz>
In-Reply-To: <20120515131453.GA1936@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205151529.01603.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 15. Mai 2012, 15:14:57 schrieb Pavel Machek:
> If I suspend without bnep0 active, resume works. 
> 
> (This has worked before, but "before" may mean 3.2 in this case).
> 
> Can someone test/reproduce this? Ideas?
> 
>                                                                         Pavel
> 
> PS: Under normal suspend/resume, I see these warnings in the
> log. Maybe relevant?

Most likely. Something has introduced a bug that crashes if the controller
over which a bnep is run is getting away. Does it survive a surprise removal
of the BT device while bnep is up?

	Regards
		Oliver
