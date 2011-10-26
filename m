Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab1JZX7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 19:59:05 -0400
Received: from smtp.outflux.net ([198.145.64.163]:33059 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab1JZX7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 19:59:03 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Oct 2011 19:59:03 EDT
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH v6 0/3] security: Yama LSM
Date: Wed, 26 Oct 2011 16:49:13 -0700
Message-Id: <1319672956-17114-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.5.4
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed at the Linux Security Summit, I'm resubmitting this
code. As an LSM, it has coherent policy around expanding specific DAC
behaviors. There is no need for it to be a full-blown MAC, since it is
not intended to be one, but rather to be a simplified expansion to DAC,
with system-wide knobs. See the specific patches for details...

Thanks,

-Kees

