Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab1KVWhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:37:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33470 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab1KVWhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:37:03 -0500
Date: Tue, 22 Nov 2011 14:28:09 -0800
From: Greg KH <gregkh@suse.de>
To: Corentin Chary <corentincj@iksaif.net>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/15] samsung-laptop: dump model and version informations
Message-ID: <20111122222809.GN24283@suse.de>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
 <1321999366-23784-15-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321999366-23784-15-git-send-email-corentincj@iksaif.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:02:45PM +0100, Corentin Chary wrote:
> We still need to figure out exactly what each of different fields
> represent, but they contain at least model and version informatiosn.
> 
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>

For every time the driver loads?  That's not nice, how about putting
this into debugfs instead?

thanks,

greg k-h
