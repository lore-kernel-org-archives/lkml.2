Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab1ISGPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 02:15:08 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:45088 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab1ISGPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 02:15:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:subject
	:cc:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=DWbHznm9poLJ/nJq6F3
	Y7owF/Z8maADTkB/PIwVqzzX9Di5TtJElwou4Bf6nCHZqNLksP1g1oUwTE/2lQTP
	bZEp4lKlx6iJd4SUsqoyM8HT68oWaNnxz4ianjakOKszCb16iP/SnqDJQyQmRlFe
	AZDEU4Wt+tKv8/217ODZ6pmc=
From: Junio C Hamano <junio@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.7.rc2
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Sun, 18 Sep 2011 23:15:01 -0700
Message-ID: <7vfwjtawii.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: B6798D06-E286-11E0-989C-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate Git 1.7.7.rc2 is available but unfortunately not at
the usual places. Even so (rather, exactly because it is in unusual
places, so we are likely to have smaller number of casual observers who
grab and build them), please test it to help us make the upcoming release
as solid as we could.

A release candidate tarball is found at:

    http://code.google.com/p/git-core/downloads/list
  
and its SHA-1 checksum is:

1e0e035148df279af689131273570a7dde45950b  git-1.7.7.rc2.tar.gz

Also the following public repositories all have a copy of the v1.7.7-rc2
tag and the master branch that the tag points at:

	url = git://repo.or.cz/alt-git.git
	url = https://code.google.com/p/git-core/
	url = git://git.sourceforge.jp/gitroot/git-core/git.git
	url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
	url = https://github.com/gitster/git

----------------------------------------------------------------

Changes since v1.7.7-rc1 are as follows:

Bryan Jacobs (1):
      git-svn: teach git-svn to populate svn:mergeinfo

Frédéric Heitzmann (1):
      Disambiguate duplicate t9160* tests

Junio C Hamano (2):
      branch --set-upstream: regression fix
      Git 1.7.7-rc2

Pang Yan Han (1):
      format-patch: ignore ui.color
