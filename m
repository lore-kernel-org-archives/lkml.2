Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab1KIIzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:55:08 -0500
Received: from host86-160-104-197.range86-160.btcentralplus.com ([86.160.104.197]:50145
	"EHLO oak.selfip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab1KIIzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:55:07 -0500
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Nov 2011 03:55:07 EST
Message-ID: <4EBA3E3E.9060402@oak.selfip.net>
Date: Wed, 09 Nov 2011 08:47:58 +0000
From: Dave Haywood <tla@oak.selfip.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111103 Thunderbird/8.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Build warning: kernel/trace/trace.c (v3.2-rc1-90-g19e0baf)
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  Noticed this new warning in the build of kernel v3.2-rc1-90-g19e0baf:

  CC      kernel/trace/trace.o
kernel/trace/trace.c: In function 'tracing_mark_write':
kernel/trace/trace.c:3644:8: warning: 'page2' may be used uninitialized in this function

  Regards,

Dave.


