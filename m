Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab0IVTu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 15:50:56 -0400
Received: from mx2.compro.net ([12.186.155.4]:44420 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab0IVTuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 15:50:55 -0400
X-Greylist: delayed 846 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Sep 2010 15:50:55 EDT
X-IronPort-AV: E=Sophos;i="4.57,219,1283745600"; 
   d="scan'208";a="5845344"
Message-ID: <4C9A5AD0.5070804@compro.net>
Date: Wed, 22 Sep 2010 15:36:48 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: line BRK detection on ttyS0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does the kernel support sending a SIGINT from a line BRK on ttyS0 to a thread of a process
where the process has a controlling terminal that is NOT ttyS0 and the thread is using ttyS0
in a cfmakeraw mode? I see doc that implies that ttyS0 must be the controlling terminal but
can my thread have a controlling terminal while my main process has it's own? My thread
cannot use the \377 \0 \0 char sequence because it is receiving and transmitting 8-bit binary
data. Is there a way for the kernel to inform my thread, not my main process, of a line BRK?
Or a way for my thread to ask the kernel if a line BRK occurred on ttyS0?

Thanks and regards
Mark

