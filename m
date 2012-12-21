Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211Ab2LUHGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 02:06:04 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:36969 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab2LUHF4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 02:05:56 -0500
Date: Fri, 21 Dec 2012 01:05:48 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [GIT PULL] user namespace and namespace infrastructure changes
 for 3.8
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
In-Reply-To: <87wqwggtcu.fsf@xmission.com> (from ebiederm@xmission.com on
	Mon Dec 17 17:18:57 2012)
X-Mailer: Balsa 2.4.11
Message-Id: <1356073548.24099.26@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 05:18:57 PM, Eric W. Biederman wrote:
> Work remains to make it safe to build user namespaces and 9p, afs,
> ceph, cifs, coda, gfs2, ncpfs, nfs, nfsd, ocfs2, and xfs so the  
> Kconfig
> guard remains in place preventing that user namespaces from being  
> built
> when any of those filesystems are enabled.

What work specifically?

Rob