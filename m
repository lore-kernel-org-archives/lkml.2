Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab1JFNCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:02:50 -0400
Received: from lo.gmane.org ([80.91.229.12]:33384 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425Ab1JFNCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:02:49 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?UTF-8?B?U3ZlbiBLw7ZobGVy?= <sven.koehler@gmail.com>
Subject: Re: Linux 3.0.5
Date: Thu, 06 Oct 2011 15:02:31 +0200
Message-ID: <4E8DA6E7.3010105@gmail.com>
References: <20111003203249.GA22113@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: horkheimer.ti5.tu-harburg.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111004 Thunderbird/7.0.1
In-Reply-To: <20111003203249.GA22113@kroah.com>
Cc: stable@linux.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's an error in 3.0.5:

# LANG=C make all
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC      drivers/gpu/drm/radeon/r100.o
drivers/gpu/drm/radeon/r100.c: In function 'r100_copy_blit':
drivers/gpu/drm/radeon/r100.c:776:27: error: 'num_pages' undeclared
(first use in this function)
drivers/gpu/drm/radeon/r100.c:776:27: note: each undeclared identifier
is reported only once for each function it appears in
make[4]: *** [drivers/gpu/drm/radeon/r100.o] Error 1
make[3]: *** [drivers/gpu/drm/radeon] Error 2
make[2]: *** [drivers/gpu/drm] Error 2
make[1]: *** [drivers/gpu] Error 2
make: *** [drivers] Error 2


3.0.4 compiles just fine with the same config file.


Regards,
  Sven Köhler

