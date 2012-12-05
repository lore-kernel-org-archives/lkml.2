Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2LEBrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 20:47:48 -0500
Received: from ozlabs.org ([203.10.76.45]:49015 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab2LEBrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 20:47:43 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
        "David Howells" <dhowells@redhat.com>
Subject: [PULL] More module signing fixes.
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 05 Dec 2012 12:15:19 +1030
Message-ID: <87624hgtlc.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David gave me these a month ago, during my git workflow churn :(

The following changes since commit df2fc246c8ee8b6067af1fa55d3bc23107457f61:

  Merge branch 'fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux (2012-12-04 09:32:12 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git 

for you to fetch changes up to f3537f91f9be2ce5fcbaa1aa6d787ad0436daec6:

  ASN.1: Fix an indefinite length skip error (2012-12-05 11:27:39 +1030)

----------------------------------------------------------------
David Howells (2):
      MODSIGN: Don't use enum-type bitfields in module signature info block
      ASN.1: Fix an indefinite length skip error

 kernel/module_signing.c |   14 +++++++-------
 lib/asn1_decoder.c      |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)
