Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936Ab2CFK2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 05:28:21 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41170 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517Ab2CFK2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 05:28:19 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of sumit.semwal@linaro.org designates 10.224.218.195 as permitted sender) smtp.mail=sumit.semwal@linaro.org
MIME-Version: 1.0
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Tue, 6 Mar 2012 15:57:59 +0530
Message-ID: <CAO_48GEk+yQxrjvd4L_zeQu5Wu9E2HM7H=a5yNVfa6ED_4icNA@mail.gmail.com>
Subject: dma-buf feature tree: working model
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Since the inclusion of dma-buf buffer sharing framework in 3.3 (thanks
to Dave Airlie primarily), I have been volunteered to be its
maintainer.

Obviously there is a need for some simple rules about the dma-buf
feature tree, so here we are:

- there will be a 'for-next' branch for (N+1), which will open around
-Nrc1, and close about 1-2 weeks before the (N+1)merge opens.

- there will be a 'fixes' branch, which will take fixes after the
for-next pull request is sent upstream.
  - after -rc2, regression fixes only.
  - after -rc4/5, only revert and disable patches. The real fix should
then be targeted at for-next.

- to stop me from pushing useless stuff, I will merge my own patches
only after sufficient review on our mailing lists. If you see me
breaking this rule, please shout out at me _publicly_ at the top of
your voice.


Being a 'first-time-maintainer', I am very willing to learn
on-the-job, though I might still take cover under the
'first-time-maintainer' umbrella [for sometime :)] for any stupid acts
I might commit.


The tree resides at: git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git

At present, the mailing lists are: linux-media@vger.kernel.org,
dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, in
addition to lkml.

Comments, flames and suggestions highly welcome.

(I have been 'influenced' quite a bit from Daniel Vetter's model for
the drm/i915 -next tree [thank you, DanVet!], but any errors/omissions
are entirely mine.)

Thanks and regards,
~Sumit.
