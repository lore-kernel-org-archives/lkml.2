Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab1GHM4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 08:56:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33636 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab1GHM4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 08:56:18 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Hans-Peter Jansen" <hpj@urpla.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, hooanon05@yahoo.co.jp
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
	<20110608153208.dc705cda.akpm@linux-foundation.org>
	<201107052154.32606.hpj@urpla.net>
Date: Fri, 08 Jul 2011 14:57:09 +0200
In-Reply-To: <201107052154.32606.hpj@urpla.net> (Hans-Peter Jansen's message
	of "Tue, 5 Jul 2011 21:54:30 +0200")
Message-ID: <87box52amy.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Hans-Peter Jansen" <hpj@urpla.net> writes:

> All kodos to you, Miklos. While I'm still missing a major feature from 
> overlayfs that is a NFS as upper layer, it provides a fairly good 
> start. A commitment from you, that such an extension is considered for 
> inclusion - given, that it appears one day - is appreciated. Also, 
> since xattr support is available for NFS,

AFAIK development of generic xattr support on NFS stopped some time ago.

> it would be nice to outline, what is missing for such an
> implementation from overlayfs's POV.

Allow using namspace polluting xattr replacements, such as aufs is
doing.

But why?  Why is it better to do the overlaying on the client instead of
the server?

Thanks,
Miklos
