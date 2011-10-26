Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751036Ab1JZSyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 14:54:37 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:32975 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750802Ab1JZSyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 14:54:36 -0400
Message-ID: <4EA85764.60309@xenotime.net>
Date: Wed, 26 Oct 2011 11:54:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Michael Witten <mfwitten@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [git pull] Documentation: DocBook/drm, basic copyediting
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from
  git://git.kernel.org/pub/scm/linux/kernel/git/rdunlap/linux-docs.git  docs-move

to get these changes from Michael Witten:

  Documentation/DocBook/drm.tmpl | 308 +++++++++++++++++++++------------------
  drivers/gpu/drm/i915/i915_drv.c|   4 +-
  2 files changed, 170 insertions(+), 142 deletions(-)


Note:  Please check that I haven't mucked up somewhere, because this:
$ git diff -M --stat --summary master..HEAD

shows me more than the changes above.
Maybe that's the wrong command options to use?

thanks,
-- 
~Randy
