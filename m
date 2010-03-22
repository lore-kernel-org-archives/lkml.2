Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab0CVCBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 22:01:14 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:40980 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab0CVCBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 22:01:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type; q=dns; s=sasl; b=x4K
	YpEl3ddY+znSkgKWnxsm8KMWsNbi6fR9RaCBs0XrtjTQFs7opw6h80ZmjdxbnJYt
	smg+gESK+58l/dWRX+xuNlEKz5I2oiQKSNTE0PoBeuZqP5Hk03jquDjEFg/1RkPG
	46py7iYyfa4fdh6qTrDcTUhmm74U4Kmv27KYWt4o=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.0.3
From: Junio C Hamano <gitster@pobox.com>
Date: Sun, 21 Mar 2010 19:00:59 -0700
Message-ID: <7vr5nd2jz8.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: C69634D4-3556-11DF-AFAF-D033EE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.7.0.3 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.0.3.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.0.3.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.0.3.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.7.0.3-1.fc11.$arch.rpm	(RPM)

Git v1.7.0.3 Release Notes
==========================

Fixes since v1.7.0.2
--------------------

 * Object files are created in a more ACL friendly way in repositories
   where group permission is ACL controlled.

 * "git add -i" didn't handle a deleted path very well.

 * "git blame" padded line numbers with one extra SP when the total number
   of lines was one less than multiple of ten due to an off-by-one error.

 * "git fetch --all/--multi" used to discard information for remotes that
   are fetched earlier.

 * "git log --author=me --grep=it" tried to find commits that have "it"
   or are written by "me", instead of the ones that have "it" _and_ are
   written by "me".

 * "git log -g branch" misbehaved when there was no entries in the reflog
   for the named branch.

 * "git mailinfo" (hence "git am") incorrectly removed initial indent from
   paragraphs.

 * "git prune" and "git reflog" (hence "git gc" as well) didn't honor
   an instruction never to expire by setting gc.reflogexpire to never.

 * "git push" misbehaved when branch.<name>.merge was configured without
   matching branch.<name>.remote.

And other minor fixes and documentation updates.
