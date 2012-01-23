Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2AWOYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 09:24:43 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64987 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab2AWOYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 09:24:41 -0500
Message-Id: <20120123142036.025893883@openvz.org>
User-Agent: quilt/0.48-1
Date: Mon, 23 Jan 2012 18:20:36 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: [patch 0/4] A few patches in a sake of c/r functionality
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are a few patches in a sake of c/r. Nothing really
serious except a new kcmp syscall I think. Please review,
comments are really appreciated!

	Cyrill
