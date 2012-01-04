Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab2ADM5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 07:57:18 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65421 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab2ADM5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 07:57:15 -0500
Date: Wed, 4 Jan 2012 16:57:10 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Hughes <hughsient@gmail.com>,
        Daniel Nicoletti <dantti12@gmail.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH RFC V2 0/4] Add "scope" to power supplies
Message-ID: <20120104125710.GA15218@oksana.dev.rtsoft.ru>
References: <cover.1323454016.git.jeremy@goop.org>
 <20120104051139.GA8081@oksana.dev.rtsoft.ru>
 <alpine.LNX.2.00.1201041347530.24984@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1201041347530.24984@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 01:48:40PM +0100, Jiri Kosina wrote:
[...]
> > Pulled into battery-2.6.git, thank you!
> 
> Thanks. Looking at the tree ... in case you are going to rebase the 
> branch, please add
> 
> 	Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> or at least
> 
> 	Acked-by: Jiri Kosina <jkosina@suse.cz>
> 
> to patches touching drivers/hid. Thanks,

Yeah, since I just pulled that tree, I didn't have a chance to insert
your Ack. But if I ever rebase the tree, I'll add it.

In any case, I'll mention your ack when I send a pull request to
Linus.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
