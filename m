Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599Ab0EMW3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:29:12 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:55987 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab0EMW3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:29:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=rGiOgkHCrgqGAU0uaVU8atPMK8UDDVJTSrBmzIdrlzGfN0FqnbdD4fk8K7aGJP+YAg
         mJHVOhwayMd/vdDBz8Ng9yrSfjSGHgt1AF+VlD5TL8FKqrWaYD9AT6hCVGtMtx9qm79F
         /lJtnsGbpKSxeQ3admbME259+uU9H/34x6VXE=
MIME-Version: 1.0
Date: Fri, 14 May 2010 03:59:08 +0530
Message-ID: <AANLkTikfzHWeVjto4Q8bWDie_5BjRz3V0fc3LW7k4uob@mail.gmail.com>
Subject: render error detected, EIR: 0x00000010
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, dri-devel@lists.freedesktop.org,
       Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chris,

I am also getting display error on another PC :

[   34.198957] render error detected, EIR: 0x00000010
[   34.198972] [drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010, masking
[   34.198998] render error detected, EIR: 0x00000010


dmesg : http://userweb.kernel.org/~jaswinder/P4_HT/dmesg-2634-rc7-tip.txt
.config : http://userweb.kernel.org/~jaswinder/P4_HT/config-2634-rc7-tip.txt
i915_handle_error :
http://userweb.kernel.org/~jaswinder/P4_HT/i915_error_state_P4.txt


If you need more information, please let me know.

Thanks,
--
Jaswinder Singh.
