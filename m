Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478Ab1EXWF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 18:05:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57926 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab1EXWF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 18:05:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=mnE20s7ZfPdOXjUKykkdpXUntZTbm9Euxa27ZfRgKGsabOiQwFryK10XF2C2DoM/AR
         l3FiSD77upvVvQlva6c6JocAEPRtSRizJfZkVAM+q6kdZRdAEqe0k44We7Xzuca7RfZL
         HyAJeRQHmzxF1/GkEwcHLIDK2IiHV3qMYUaQs=
MIME-Version: 1.0
Date: Tue, 24 May 2011 15:05:27 -0700
X-Google-Sender-Auth: gRemvdKXCfE8gyWy72p4iffT62s
Message-ID: <BANLkTimnTkw1of97dvc4Gtsw6Bd6bgFbUQ@mail.gmail.com>
Subject: warning about ib_cache_cleanup
From: Yinghai Lu <yinghai@kernel.org>
To: Roland Dreier <roland@purestorage.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.init.text+0x439b9): Section mismatch in reference
from the function ib_core_init() to the function
.exit.text:ib_cache_cleanup()
The function __init ib_core_init() references
a function __exit ib_cache_cleanup().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
ib_cache_cleanup() so it may be used outside an exit section.
