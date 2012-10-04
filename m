Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab2JDKXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:23:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64042 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab2JDKXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:23:00 -0400
Date: Thu, 4 Oct 2012 03:20:13 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org
Subject: [PATCH 0/3] A few cleanups and refactorings, sync w/ upstream
Message-ID: <20121004102013.GA23284@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pekka,

Just a few updates to vmevents:

- Some cleanups and refactorings -- needed for easier integration of
  'memory pressure' work;
- Forward to newer Linus' tree, fix conflicts.

For convenience, the merge commit and all the patches can be pulled from
this repo:

	git://git.infradead.org/users/cbou/linux-vmevent.git tags/vmevent-updates

Thanks,
Anton.
