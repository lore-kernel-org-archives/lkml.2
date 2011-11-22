Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab1KVWg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:36:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244Ab1KVWgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:36:53 -0500
Date: Tue, 22 Nov 2011 14:23:54 -0800
From: Greg KH <gregkh@suse.de>
To: Corentin Chary <corentincj@iksaif.net>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/15] samsung-laptop: add keyboard backlight support
Message-ID: <20111122222354.GK24283@suse.de>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
 <1321999366-23784-12-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321999366-23784-12-git-send-email-corentincj@iksaif.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:02:42PM +0100, Corentin Chary wrote:
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>

What happens on boxes that don't have this type of hardware?  Will the
LED device still show up, yet it will not work?

You should be able to trigger this off of the model type somehow, much
like the video backlight should work.

thanks,

greg k-h
