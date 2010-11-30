Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab0K3OY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 09:24:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233Ab0K3OY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 09:24:58 -0500
Date: Tue, 30 Nov 2010 15:24:56 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Philipp Merkel <mail@philmerk.de>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] hid: egalax: Rework to include Joojoo and Wetab
 support
In-Reply-To: <20101130090843.GB3952@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1011301524390.23409@pobox.suse.cz>
References: <1291016612-25102-1-git-send-email-rydberg@euromail.se> <alpine.LNX.2.00.1011291248290.981@pobox.suse.cz> <20101130090843.GB3952@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, Dmitry Torokhov wrote:

> > How are we going to handle this? Dmitry, what is your plan with input-mt 
> > slots changes?
> 
> Hmm, I could create a branch for MT work and you could pull from it...

That would work nicely for me, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
