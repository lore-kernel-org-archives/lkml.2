Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab0DSPJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 11:09:46 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42781 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab0DSPJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 11:09:45 -0400
X-Greylist: delayed 953 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Apr 2010 11:09:44 EDT
To: Valerie Aurora <vaurora@redhat.com>
CC: jblunck@suse.de, jamie@shareable.org, dwmw2@infradead.org,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, tytso@mit.edu,
       linux-ext4@vger.kernel.org
In-reply-to: <20100419142315.GA2688@shell> (message from Valerie Aurora on
	Mon, 19 Apr 2010 10:23:15 -0400)
Subject: Re: [PATCH 13/35] fallthru: ext2 fallthru support
References: <1271372682-21225-10-git-send-email-vaurora@redhat.com> <1271372682-21225-11-git-send-email-vaurora@redhat.com> <1271372682-21225-12-git-send-email-vaurora@redhat.com> <1271372682-21225-13-git-send-email-vaurora@redhat.com> <1271372682-21225-14-git-send-email-vaurora@redhat.com> <20100419124025.GG10776@bolzano.suse.de> <1271682168.14748.718.camel@macbook.infradead.org> <20100419132344.GI10776@bolzano.suse.de> <20100419133028.GA3631@shareable.org> <20100419141248.GK10776@bolzano.suse.de> <20100419142315.GA2688@shell>
Message-Id: <E1O3sLi-0008EA-QW@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 19 Apr 2010 16:53:22 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Apr 2010, Valerie Aurora wrote:
> I don't recall there being any technical reason not to look up the
> real inode number.  I just wrote it that we because I was lazy.  So I
> like returning the directory's d_ino better than a single magic
> number, but I'd at least like to try returning the real inode number
> too.

Note, "struct dirent" doesn't have d_dev, so you really can't return
the "real" inode number, that's on a different filesystem and just a
random number in the context of the the readdir in question.

Thanks,
Miklos
