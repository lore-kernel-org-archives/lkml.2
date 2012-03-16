Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031293Ab2CPVDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:03:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61248 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623Ab2CPVDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:03:48 -0400
Message-Id: <20120316205556.595309230@openvz.org>
User-Agent: quilt/0.48-1
Date: Sat, 17 Mar 2012 00:55:56 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: [patch 0/2] [PATCH 0/2] prctl extension in a sake of c/r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series is resulting one from long discuss about ability
to restore /proc/pid/exe. Hope it will fit everyone.

While exe symlink has been reviewed (and actually fixed,
thanks a lot Oleg!) I've got no opinions on "Add ability
to get clear_tid_address" one. Anyway both patches have
been tested intensively.

	Cyrill
