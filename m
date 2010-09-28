Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab0I1NgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:36:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54464 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab0I1NgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:36:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=maHM5pFpQAUjgrctjJf/Da0Jh2XX/0Clz3/M2LHrouMRdwGZzkHiEyjPYwtTultgzB
         ZNjTbJ9m4V2ZsLVRBZTirQojH9lP59msY1sqQsC2pg8Tuj75n1XCc71FLwRWD+GxMHMH
         PO1ZCWz4e3N+Yz3rM21z6up7R7hAtYY/nkfcI=
MIME-Version: 1.0
Date: Tue, 28 Sep 2010 21:36:09 +0800
Message-ID: <AANLkTi=dqiY+kxfW4k+ke6M5J45WbM8j2Vi=y9VxYOY0@mail.gmail.com>
Subject: drivers/gpu/drm/i915/i915_suspend.c:792: error: 'const struct
 intel_device_info' has no member named 'gen'
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      drivers/gpu/drm/i915/i915_suspend.o
drivers/gpu/drm/i915/i915_suspend.c: In function 'i915_save_state':
drivers/gpu/drm/i915/i915_suspend.c:792: error: 'const struct
intel_device_info' has no member named 'gen'
drivers/gpu/drm/i915/i915_suspend.c: In function 'i915_restore_state':
drivers/gpu/drm/i915/i915_suspend.c:827: error: 'const struct
intel_device_info' has no member named 'gen'
make[4]: *** [drivers/gpu/drm/i915/i915_suspend.o] Error 1
make[3]: *** [drivers/gpu/drm/i915] Error 2
make[2]: *** [drivers/gpu/drm] Error 2
make[1]: *** [drivers/gpu] Error 2
make: *** [drivers] Error 2


I started happening 2 weeks ago. Does anyone has a fix for this?

Thanks
Jeff
