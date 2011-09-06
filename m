Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab1IFXrC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 19:47:02 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:50160 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355Ab1IFXq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 19:46:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
	:cc:date:message-id:mime-version:content-type; q=dns; s=sasl; b=
	WOToK0nqozH2vZMNziMIi2wCmjVuYW+VPHlpRFxUCuT6cjaGNDuwFWCDxEEE5gGp
	JeWrVvkxCEAdnM01B5A1xPFJ3AZH7FCWAu9xe8Z6OW0/RXTaJyoUXDRQVHyUD7aE
	lhb6tG0SDJXI4avAAnnMFbVxAOYs9oyZN1EZ27rtjDQ=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.6.2
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Tue, 06 Sep 2011 16:46:54 -0700
Message-ID: <7vvct55j4h.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 80FF5D2A-D8E2-11E0-AB2B-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've tagged the latest maintenance release Git 1.7.6.2 but unfortunately
the tarballs are not available at the usual places. The release can be
fetched from any of the following repositories, at the tip of 'maint'
branch.

	git://repo.or.cz/alt-git.git
	https://github.com/gitster/git
	https://code.google.com/p/git-core/
	git://git.sourceforge.jp/gitroot/git-core/git.git
	git://git-core.git.sourceforge.net/gitroot/git-core/git-core

This is primarily to fix "git push --quiet" breakage in 1.7.6.1.

----------------------------------------------------------------

Changes since v1.7.6.1 are as follows:

Junio C Hamano (3):
      whitespace: have SP on both sides of an assignment "="
      Revert "Merge branch 'cb/maint-quiet-push' into maint"
      Git 1.7.6.2

Pang Yan Han (1):
      update-ref: whitespace fix

Thomas Rast (1):
      Documentation: clarify effects of -- <path> arguments

