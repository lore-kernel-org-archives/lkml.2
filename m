Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1HAM1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 08:27:06 -0400
Received: from cernmx31.cern.ch ([137.138.144.179]:26097 "EHLO
	CERNMX31.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1HAM1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 08:27:00 -0400
Date: Mon, 1 Aug 2011 14:24:02 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Dan Carpenter <error27@gmail.com>
CC: <gregkh@suse.de>, <martyn.welch@ge.com>, <devel@driverdev.osuosl.org>,
        <cota@braap.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] staging: vme: make [alloc|free]_consistent bridge
 specific
Message-ID: <20110801122402.GA7010@becoht-mvanga>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>, gregkh@suse.de,
	martyn.welch@ge.com, devel@driverdev.osuosl.org, cota@braap.org,
	linux-kernel@vger.kernel.org
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
 <1312194053-32310-4-git-send-email-manohar.vanga@cern.ch>
 <20110801111050.GG5575@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110801111050.GG5575@shale.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

> The user wouldn't know which driver is printing the error.
> ...
> Could probably be improved as well.

Thanks! I have added the bridge name to the output here.

P.S. Should I send this patch immediately or wait till I have some
feedback on the others and resend them all at once?

--
/manohar
