Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab2GWR0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:26:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50030 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab2GWR0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:26:30 -0400
MIME-Version: 1.0
Date: Mon, 23 Jul 2012 10:26:29 -0700
X-Google-Sender-Auth: 3hN17seY8bQc_vhcAEM4g7vQW8M
Message-ID: <CA+8MBbLOi=GEkewV9RR40exw4KMP85LC8J3uNLQZQcKEhMWDCA@mail.gmail.com>
Subject: checkpatch should not complain about 'Suggested-by:'
From: Tony Luck <tony.luck@intel.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch just gave me:

   WARNING: Non-standard signature: Suggested-by:

There are over 500 instances of 'Suggested-by:', and it seems
to have some value in tracking history and awarding credit
where it is due.

"Reported-and-tested-by:" is also in regular use, but not
in the list of "standard" signatures.

-Tony
