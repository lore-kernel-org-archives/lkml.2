Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab1JKKwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 06:52:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab1JKKwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 06:52:22 -0400
Date: Tue, 11 Oct 2011 12:52:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@googlemail.com>,
        Bastien Nocera <hadess@hadess.net>,
        Jason Gerecke <killertofu@gmail.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: linux-next: manual merge of the hid tree with Linus' tree
In-Reply-To: <20111011143755.68708e9f278048e12321a9e6@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1110111251580.14768@pobox.suse.cz>
References: <20111011143755.68708e9f278048e12321a9e6@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Oct 2011, Stephen Rothwell wrote:

> Hi Jiri,
> 
> Today's linux-next merge of the hid tree got a conflict in
> drivers/hid/hid-wacom.c between commit 3512069eefd3 ("Input: wacom - add
> POINTER and DIRECT device properties") from Linus' tree and commit
> 3797ef6b6bc0 ("HID: wacom: Set input bits before registration") from the
> hid tree.
> 
> I fixed it up (maybe - see below) and can carry the fix as necessary.

That is a correct resolution, thanks.

-- 
Jiri Kosina
SUSE Labs
