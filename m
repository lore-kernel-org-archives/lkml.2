Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1KVWjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:39:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758689Ab1KVWga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:36:30 -0500
Date: Tue, 22 Nov 2011 14:19:16 -0800
From: Greg KH <gregkh@suse.de>
To: Corentin Chary <corentincj@iksaif.net>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/15] samsung-laptop: move code into init/exit functions
Message-ID: <20111122221916.GD24283@suse.de>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
 <1321999366-23784-3-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321999366-23784-3-git-send-email-corentincj@iksaif.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:02:33PM +0100, Corentin Chary wrote:
> Create _init()/_exit() function for each subsystem, remove
> the local struct samsung_laptop * and only keep a
> struct platform_device * that can only be used in samsung_init()
> and samsung_exit().
> 
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>

It seems a little gratitous, but hey, if you want to maintain this
driver, I have no objection to you rewriting the thing :)

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

