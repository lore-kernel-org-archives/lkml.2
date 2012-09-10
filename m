Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab2IJBrJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 21:47:09 -0400
Received: from ares07.inai.de ([5.9.24.206]:51326 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755905Ab2IJBrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 21:47:07 -0400
Date: Mon, 10 Sep 2012 03:47:04 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org, goran.cetusic@gmail.com, romain@orebokech.com,
        mszeredi@suse.cz
Subject: Re: [PATCH 07/13] overlay: overlay filesystem documentation
In-Reply-To: <1345045700-9062-8-git-send-email-miklos@szeredi.hu>
Message-ID: <alpine.LNX.2.01.1209100333290.22738@frira.zrqbmnf.qr>
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu> <1345045700-9062-8-git-send-email-miklos@szeredi.hu>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2012-08-15 17:48, Miklos Szeredi wrote:
>[...]
>+This is most obvious from the 'st_dev' field returned by stat(2).
>+
>+While directories will report an st_dev from the overlay-filesystem,
>+all non-directory objects will report an st_dev from the lower or
>+upper filesystem that is providing the object.

That would seem to render `rsync --one-filesystem` unusable?
(or similar options in other tools)


