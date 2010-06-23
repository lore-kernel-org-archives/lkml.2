Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0FWBXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 21:23:46 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56300 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752178Ab0FWBXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 21:23:45 -0400
X-Sasl-enc: LrWglYCYrcEjddEifPUcUEEJUYk4yQ/54gWOluLGAlTn 1277256223
Subject: Re: [autofs] [PATCH 04/38] autofs4: Save autofs trigger's vfsmount
 in super block info
From: Ian Kent <raven@themaw.net>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
       vaurora@redhat.com, autofs@linux.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, jblunck@suse.de
In-Reply-To: <26799.1277185756@jrobl>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
	 <1276627208-17242-5-git-send-email-vaurora@redhat.com>
	 <1276661043.2339.35.camel@localhost> <1277091579.3827.9.camel@localhost>
	 <E1OQghj-0001Bt-RU@pomaz-ex.szeredi.hu> <1277181999.2829.2.camel@localhost>
	 <26799.1277185756@jrobl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Jun 2010 09:23:34 +0800
Message-ID: <1277256214.2848.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 14:49 +0900, J. R. Okajima wrote:
> 
> Or how about iterate_mounts() instead of loop over dentries?
> For example (just a example),

I may be missing something about this, but why is it safe to use
iterate_mounts(), since it doesn't take the vfsmount_lock when
traversing the list of mounts?

Ian


