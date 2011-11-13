Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab1KMUC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 15:02:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab1KMUC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 15:02:58 -0500
Date: Sun, 13 Nov 2011 21:02:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: KY Srinivasan <kys@microsoft.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "joe@perches.com" <joe@perches.com>
Subject: RE: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481AA69FD0@TK5EX14MBXC128.redmond.corp.microsoft.com>
Message-ID: <alpine.LNX.2.00.1111132102070.15187@pobox.suse.cz>
References: <1319841316-29136-1-git-send-email-kys@microsoft.com> <20111105064739.GA31111@core.coreip.homeip.net> <6E21E5352C11B742B20C142EB499E0481AA68580@TK5EX14MBXC128.redmond.corp.microsoft.com> <20111107055109.GA21095@core.coreip.homeip.net>
 <6E21E5352C11B742B20C142EB499E0481AA69FD0@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Nov 2011, KY Srinivasan wrote:

> If it is ok with you, I will send the patch out with all the other 
> cleanup that you had suggested.

Yes please, Dmitry has done an excellent review here (as usual). So I will 
not be merging the latest patch you have sent just now and will wait for 
respin with Dmitry's comments incorporated.

-- 
Jiri Kosina
SUSE Labs
