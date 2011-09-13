Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab1IMFHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 01:07:13 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47191 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab1IMFHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 01:07:12 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Cc: dhowells@redhat.com, agruen@kernel.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V6 00/26] New ACL format for better NFSv4 acl interoperability
In-Reply-To: <8331.1315866422@redhat.com>
References: <20110912222306.GB17483@fieldses.org> <25175.1315572498@redhat.com> <1315243548-18664-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <26458.1315577016@redhat.com> <8331.1315866422@redhat.com>
User-Agent: Notmuch/0.5-318-g52e4ded (http://notmuchmail.org) Emacs/23.2.1 (x86_64-pc-linux-gnu)
Date: Tue, 13 Sep 2011 10:37:00 +0530
Message-ID: <87sjo19gjv.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Sep 2011 23:27:02 +0100, David Howells <dhowells@redhat.com> wrote:
> J. Bruce Fields <bfields@fieldses.org> wrote:
> 
> > Probably the documentation belongs in man pages.  Which I think they've
> > done, but alas the git repos (on kernel.org) aren't accesible right
> > now....
> 
> There is also an in-kernel API that filesystems have to deal with if they want
> to support richacls.  See the ext4 patches...  There should probably be one
> document describing how to 'use' ACLs of all kinds from a filesystem internals
> point of view somewhere under Documentation/filesystems/
> 

setattr callback should call richacl_chmod when called with ATTR_MODE
and we should have new xattr callbacks for "system.richacl" . Those are
the only two changes needed for file system.

-aneesh
