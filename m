Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab0LCC1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 21:27:42 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:55113 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab0LCC1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 21:27:41 -0500
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Dec 2010 21:27:41 EST
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type; q=dns; s=sasl; b=Z/E
	ekz8GYMC1e/RS30BlQ/3l8hZUyU8/7qQXfc+hm475V7Wl+aHnbZAGj4x9r2+GuBI
	oWgHlROa8J8rTFe+bv0c2qhgNVdpD2lRH76Ly5ZcuIzgbZjr+wJtH5UI5bl85yvk
	Z8niICK0LRCu36Jdgm1bqs3pex2yjreC4EEVE8TE=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.0.8, 1.7.1.3 and 1.7.2.4
From: Junio C Hamano <gitster@pobox.com>
Date: Thu, 02 Dec 2010 18:21:13 -0800
Message-ID: <7vk4jrppeu.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 0EF297A8-FE84-11DF-A637-CDEAE6EC64FC-77302942!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few maintenance releases of Git 1.7.0.8, 1.7.1.3 and 1.7.2.4 are
available at the usual places (replace $V below with these version
numbers):

  http://www.kernel.org/pub/software/scm/git/

  git-$V.tar.{gz,bz2}			(source tarball)
  git-htmldocs-$V.tar.{gz,bz2}		(preformatted docs)
  git-manpages-$V.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-$V-1.fc11.$arch.rpm	(RPM)

These are primarily to backport support for the new "add.ignoreErrors"
name given to the existing "add.ignore-errors" configuration variable.

The next version, Git 1.7.4, and future versions, will support both
old and incorrect name and the new corrected name, but without this
backport, users who want to use the new name "add.ignoreErrors" in
their repositories cannot use older versions of Git.


