Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1HaIFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 04:05:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35397 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab1HaIFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 04:05:40 -0400
Message-Id: <20110831075814.003575573@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 31 Aug 2011 11:58:14 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: containers@lists.osdl.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        James Bottomley <jbottomley@parallels.com>, Tejun Heo <tj@kernel.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: [patch 0/2] Introduce /proc/pid/map_files v6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series (I hope) do address all concerns on /proc/pid/map_files
feature. Since it needs to change proc_get_link arguments type --
such change was factored out into a separate patch.

Please review, comments/complains are *highly* appreciated!

Thanks,
  Cyrill
