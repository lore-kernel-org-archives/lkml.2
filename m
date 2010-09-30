Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab0I3AOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 20:14:10 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:41426 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab0I3AOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 20:14:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type; q=dns; s=sasl; b=FkO
	0saHVZVP/xY4FAC9YpxHLHJ5rELm16R8ehs2A9q/jPujdpB5Yd812LpNzyGpzitP
	K0PYLUSsojSYk08VvG+nBfy5yqkVl7ftOl91v288/FMWFiVo9cGqgCoXmkyzj9Gr
	ASrg28UtyTFNLsZ1U6FmyhSHyBhdgbjyLHPLpmPA=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.3.1
From: Junio C Hamano <gitster@pobox.com>
Date: Wed, 29 Sep 2010 17:13:57 -0700
Message-ID: <7vtyl8krzu.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: A191A3B8-CC27-11DF-9126-030CEE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first maintenance release of Git 1.7.3.X series, 1.7.3.1, is
available at the usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.3.1.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.3.1.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.3.1.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.7.3.1-1.fc11.$arch.rpm	(RPM)

Git v1.7.3.1 Release Notes
==========================

Fixes since v1.7.3
------------------

 * "git stash show stash@{$n}" was accidentally broken in 1.7.3 ("git
   stash show" without any argument still worked, though).

 * "git stash branch $branch stash@{$n}" was accidentally broken in
   1.7.3 and started dropping the named stash even when branch creation
   failed.

And other minor fixes and documentation updates.
