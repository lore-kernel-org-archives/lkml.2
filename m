Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab1KGGW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 01:22:26 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:51034 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751681Ab1KGGWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 01:22:25 -0500
Message-ID: <4EB778E4.3080802@xenotime.net>
Date: Sun, 06 Nov 2011 22:21:24 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Witten <mfwitten@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [git pull/retry] Documentation: DocBook/drm, basic copyediting
References: <4EA85764.60309@xenotime.net> <CA+55aFyghT3vx5Y0dPsa4sXpTV_vd0FAtzXurv1oh_26P8G7zQ@mail.gmail.com>
In-Reply-To: <CA+55aFyghT3vx5Y0dPsa4sXpTV_vd0FAtzXurv1oh_26P8G7zQ@mail.gmail.com>
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

---
