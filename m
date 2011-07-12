Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1GLP6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 11:58:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39164 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab1GLP6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 11:58:13 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Sorin Faibish" <sfaibish@emc.com>
Cc: "Ric Wheeler" <ricwheeler@gmail.com>, "Hans-Peter Jansen" <hpj@urpla.net>,
        "Andrew Morton" <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, hooanon05@yahoo.co.jp,
        "James Morris" <jmorris@redhat.com>,
        "Bruce Fields" <bfields@redhat.com>,
        "Steve Dickson" <SteveD@redhat.com>,
        "Trond Myklebust" <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
	<20110608153208.dc705cda.akpm@linux-foundation.org>
	<201107052154.32606.hpj@urpla.net>
	<87box52amy.fsf@tucsk.pomaz.szeredi.hu> <4E196175.2020307@gmail.com>
	<op.vyeog2k5rwwil4@sfaibish1.corp.emc.com>
Date: Tue, 12 Jul 2011 17:59:03 +0200
In-Reply-To: <op.vyeog2k5rwwil4@sfaibish1.corp.emc.com> (Sorin Faibish's
	message of "Sun, 10 Jul 2011 09:55:50 -0400")
Message-ID: <87bowz5w3c.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Sorin Faibish" <sfaibish@emc.com> writes:

> On Sun, 10 Jul 2011 04:23:17 -0400, Ric Wheeler <ricwheeler@gmail.com>
> wrote:
>> There is a proposed (at the IETF) standard called "labelled NFS"
>> that would allow the protocol to handle xattrs.
> Will be included in NFSv4.2. And we are already very close to a good I-D.
> Not sure that xattr change mentioned here will be included. You can look
> at the current I-D at:
> http://datatracker.ietf.org/doc/draft-quigley-nfsv4-labeled/

I skimmed the draft, and it looks like being mostly generic enough to
support any xattr, not just security labels.

But the naming and some of the requirements (such as notifying clients
on label change) are very much security label specific, forcing generic
xattr support into this protocol might not be a good idea.

I see that NFSv4 also has named attributes, which are conceptually
similar to linux xattr, but the APIs are not easily synchronized.

Doing xattr as a new protocol extension would be much easier and
cleaner, IMO.

Thanks,
Miklos
