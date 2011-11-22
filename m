Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab1KVWgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:36:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086Ab1KVWgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:36:40 -0500
Date: Tue, 22 Nov 2011 14:21:03 -0800
From: Greg KH <gregkh@suse.de>
To: Corentin Chary <corentincj@iksaif.net>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/15] samsung-laptop: remove selftest
Message-ID: <20111122222103.GG24283@suse.de>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
 <1321999366-23784-8-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321999366-23784-8-git-send-email-corentincj@iksaif.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:02:38PM +0100, Corentin Chary wrote:
> We can now do the self test using debugfs, so remove the code
> and keep the debug flag to enable more traces.
> 
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
