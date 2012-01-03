Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab2ACQtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 11:49:23 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48557 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab2ACQtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 11:49:22 -0500
MIME-Version: 1.0
In-Reply-To: <1325604356.2095.23.camel@falcor>
References: <43556.213.228.140.150.1323560920.squirrel@webmail.decimal.pt>
 <20111213180707.GI11747@quack.suse.cz> <!&!AAAAAAAAAAAYAAAAAAAAAKCACr8ZwetPrGXZsycJodKihAAAEAAAAGPJDX4w3wxIo8Onu2+q/xMBAAAAAA==@decimal.pt>
 <20120102115222.GA3626@quack.suse.cz> <20120103010826.GF3626@quack.suse.cz>
 <20120103123841.GA31457@quack.suse.cz> <1325604356.2095.23.camel@falcor>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Jan 2012 08:48:58 -0800
X-Google-Sender-Auth: y-LOtD_pIoH_GCuuy1CbucS1qeE
Message-ID: <CA+55aFzwq6XiAnX26uV+-mNsbGbnj0S=4nP5avPqKPw8OT+cmw@mail.gmail.com>
Subject: Re: Reiserfs.c bug in 3.2-rc5
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        reiserfs-devel@vger.kernel.org, haiyangz@microsoft.com,
        hjanssen@microsoft.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Morris <jmorris@namei.org>,
        Jorge Bastos <mysql.jorge@decimal.pt>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 3, 2012 at 7:25 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>
> Commit fb88c2b changed the security_old_inode_init_security() return
> code for S_PRIVATE inodes. As long as -EOPNOTSUPP is expected, probably
> should revert that as well.
>
> (I'm cc'ing the ocfs2 maintainers.)

Jan, Joel? Can you confirm? I was planning on doing 3.2 today, but
maybe I can't, or maybe we need to punt this to be a stable patch.

But maybe we can have quick testing and agreement? Does everybody
agree on both Honza's patch *and* revert of fb88c2b? Does the
EOPNOTSUPP return case match what we used to do?

                          Linus
