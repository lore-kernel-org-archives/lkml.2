Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab1KVWgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:36:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33389 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758827Ab1KVWgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:36:23 -0500
Date: Tue, 22 Nov 2011 14:18:29 -0800
From: Greg KH <gregkh@suse.de>
To: Corentin Chary <corentincj@iksaif.net>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/15] samsung-laptop: ehance SABI support
Message-ID: <20111122221829.GB24283@suse.de>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
 <1321999366-23784-6-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321999366-23784-6-git-send-email-corentincj@iksaif.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:02:36PM +0100, Corentin Chary wrote:
> * SABI command are on 16 bits, not 8

Are you sure about that?  I guess this would work, and we rely on the
bits being in the right order so everything works properly?

> * SABI can read/write up to 11 byte of data

It can?

> * There is not real difference between "get" and "set"
>   commands, so refactorise the code of both functions

Ah, nice, I always wanted to do that.

> Signed-off-by: Corentin Chary <corentincj@iksaif.net>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

