Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab1KCBfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:35:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933168Ab1KCBfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:35:44 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:56 2011
Message-Id: <20111102221456.335891562@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Josh Boyer <jwboyer@redhat.com>
Subject: [068/107] Update email address for stable patch submission
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Josh Boyer <jwboyer@redhat.com>

commit 5fa224295f0e0358c8bc0e5390702338df889def upstream.

The stable@vger.kernel.org email address has been replaced with the
stable@vger.kernel.org mailing list.  Change the stable kernel rules to
reference the new list instead of the semi-defunct email alias.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/stable_kernel_rules.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -25,13 +25,13 @@ Rules on what kind of patches are accept
 Procedure for submitting patches to the -stable tree:
 
  - Send the patch, after verifying that it follows the above rules, to
-   stable@vger.kernel.org.
+   stable@vger.kernel.org.
  - The sender will receive an ACK when the patch has been accepted into the
    queue, or a NAK if the patch is rejected.  This response might take a few
    days, according to the developer's schedules.
  - If accepted, the patch will be added to the -stable queue, for review by
    other developers and by the relevant subsystem maintainer.
- - If the stable@vger.kernel.org address is added to a patch, when it goes into
+ - If the stable@vger.kernel.org address is added to a patch, when it goes into
    Linus's tree it will automatically be emailed to the stable team.
  - Security patches should not be sent to this alias, but instead to the
    documented security@kernel.org address.


