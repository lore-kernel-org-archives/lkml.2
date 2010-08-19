Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab0HSX6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 19:58:40 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:56846 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab0HSX6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 19:58:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type; q=dns; s=sasl; b=b4G
	50jkn++AcK9sp7m2mtoEfv1DI7KfrnfZqYqQoWGlfRKX3p0oAko6O+iZGdLfMpZC
	TyanljksCqzIbw4SG5Lgrlc0V0mt0bb6oqPDj+7HTKCEvubah4T/DuF2o2+mgxtq
	1L9+cPBpk3YulDeFjivVXX8SBhkzhkAz1NTDuK6I=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.2.2
From: Junio C Hamano <gitster@pobox.com>
Date: Thu, 19 Aug 2010 16:58:27 -0700
Message-ID: <7vtymqcfz0.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: AC16672E-ABED-11DF-90FF-9056EE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.7.2.2 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.2.2.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.2.2.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.2.2.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.7.2.2-1.fc11.$arch.rpm	(RPM)

This is primarily for fixing a hanging bug in the smart http transport,
but also comes with a lot of documentation udpates.

----------------------------------------------------------------

Git v1.7.2.2 Release Notes
==========================

Fixes since v1.7.2.1
--------------------

 * Object transfer over smart http transport deadlocked the client when
   the remote HTTP server returned a failure, instead of erroring it out.

 * git-gui honors custom textconv filters when showing diff and blame;

 * git diff --relative=subdir (without the necessary trailing /) did not
   work well;

 * "git diff-files -p --submodule" was recently broken;

 * "git checkout -b n ':/token'" did not work;

 * "git index-pack" (hence "git fetch/clone/pull/push") enabled the object
   replacement machinery by mistake (it never should have);

And other minor fixes and documentation updates.
