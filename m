Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab0KLAcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 19:32:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45516 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab0KLAb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 19:31:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=GFQhDTEbLjjOzxwTJLtSoPNJAOjzXyUoLiNLTXrIiaQyCLvJCeywMeXEkg7fKwa8pV
         RUXYjYmHKXDUkp7aneJGMt+t8oMGPQMlIzwxyPjfJTbPb1b/NaZTI3+bGThg54ZLfJ0u
         +8ZjGkq5xrIyMwQfeHWSqH96tzuSGPAL3Pdl4=
MIME-Version: 1.0
Date: Fri, 12 Nov 2010 01:31:57 +0100
Message-ID: <AANLkTi=emVB3kqR322Man01sDd0DFecxzDENVCS6B1jj@mail.gmail.com>
Subject: Regressions in resume on intel graphics
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: airlied@redhat.com, jbarnes@virtuousgeek.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've noticed that after resume  with 2.6.36 kernel I need to switch
between console and back to Xorg to get usable Xsession again.
(my hw - T61, gma965, 4GB)

I've played bisect game -  and this is the first broken kernel:

---
commit 8fd4bd22350784d5b2fe9274f6790ba353976415
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Wed Jun 23 12:56:12 2010 -0700

    vt/console: try harder to print output when panicing
---

Also I'd like to increase focus on another  suspend/resume killer (at
least on my T61)
https://bugzilla.kernel.org/show_bug.cgi?id=19052
https://bugzilla.redhat.com/show_bug.cgi?id=617809

Though   disabling polling thread fixes problem for 100% it's probably
not the best fix for this problem.


Zdenek
