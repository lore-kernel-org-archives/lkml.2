Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161023Ab2CQSA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 14:00:29 -0400
Received: from vm1.a6n.de ([78.46.59.250]:36248 "EHLO vm1.a6n.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881Ab2CQSA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 14:00:28 -0400
Subject: Re: Faulty has_zero()? (was: .. anybody know of any filesystems that depend on the exact VFS 'namehash' implementation?)
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
From: Sven Anderson <sven@anderson.de>
In-Reply-To: <CA+55aFzg7Wm6hNyFLrtPB5HOdu0SSkZrbLXFJrgreEN+LYEsdg@mail.gmail.com>
Date: Sat, 17 Mar 2012 19:00:20 +0100
Cc: Chris Mason <chris.mason@oracle.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <F2F3AB09-6F88-446D-BA53-7CFF5292E1CD@anderson.de>
References: <CA+55aFyv=OKUuAV6pqdmbHeUL7Motsh+n026nWqaT63aEgBjBQ@mail.gmail.com> <20120301165726.GF23916@ZenIV.linux.org.uk> <CA+55aFzxWifxyFSpQfuztmOiyBQpYfiM560DWXoooZ8j8p3fYw@mail.gmail.com> <20120301183403.GF5054@shiny> <CA+55aFwHN_4=WOOYVC60kdSfwYautigNwTwUnjQDRa-oTanVog@mail.gmail.com> <FA611BE7-A574-444D-9C1E-7E32CB3BD659@anderson.de> <CA+55aFzg7Wm6hNyFLrtPB5HOdu0SSkZrbLXFJrgreEN+LYEsdg@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 17.03.2012 um 17:53 schrieb Linus Torvalds:
> This is why the algorithm is fundamentally little-endian only. You may
> have confused your test-case on a big-endian machine. On big-endian,
> you would need to do a byte-switching load.

Alright, I ignorantly assumed big-endian by interpreting the "first" as coming from the left side in the integer literals. *D'oh*
Sorry, and thanks for taking the time to explain it to me.


Best regards,

Sven

