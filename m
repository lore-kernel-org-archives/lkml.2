Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab1FJJcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:32:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58173 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab1FJJcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:32:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=MjOIGawwyyFWsamq09StiWyhmD4l3E21RM9fbJ7jYzB2/qHokYy+G4um3QIYUjO0l2
         w2dT6naCq+sZtiFbqh3wJNXBVrf+gBImT62FARAmUnsp4KuMhoIO0h7xemBAEEi+yXhA
         WZ6MDhfRwtrx96ZnBbFq9E/JxAw/Ggewogcmc=
From: Francis Moreau <francis.moro@gmail.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
	<20110608153208.dc705cda.akpm@linux-foundation.org>
	<20110609115934.3c53f78f@notabene.brown>
	<20110608205233.ebfedc4d.akpm@linux-foundation.org>
	<87wrgvb28a.fsf@tucsk.pomaz.szeredi.hu>
	<20110609123843.77153b27.akpm@linux-foundation.org>
	<877h8uzmsi.fsf@tucsk.pomaz.szeredi.hu> <21324.1307677721@jrobl>
Date: Fri, 10 Jun 2011 11:31:55 +0200
In-Reply-To: <21324.1307677721@jrobl> (J. R. Okajima's message of "Fri, 10 Jun
	2011 12:48:41 +0900")
Message-ID: <m2r572f2wk.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. R. Okajima" <hooanon05@yahoo.co.jp> writes:

[...]

> Aufs was rejected merging because LKML people decided that linux
> mainline will never include the union-type-filesystem but will include
> the union-type-mount (eg. UnionMount).

BTW, what is the current status of the union mount approach ?

Thanks
-- 
Francis
