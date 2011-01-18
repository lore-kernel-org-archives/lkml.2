Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab1AROnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 09:43:52 -0500
Received: from mx2.compro.net ([12.186.155.4]:56255 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab1AROnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 09:43:50 -0500
X-IronPort-AV: E=Sophos;i="4.60,339,1291611600"; 
   d="scan'208";a="6224157"
Message-ID: <4D35A725.60405@compro.net>
Date: Tue, 18 Jan 2011 09:43:49 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
CC: Mark Hounschell <dmarkh@cfl.rr.com>
Subject: cgroups inquiry
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have multiple tasks running, each with a controlling terminal. Is
there anything in cgroups that would allow me to pass a signal from one
of these tasks to all the others. It seems I can't use kill(3) because
it appears all these processes would have to be in the same process
group and only a single controlling terminal is allowed per process group??

Is this a correct assumption?

Is there a way to eliminate the "single controlling terminal"
requirement per process group?

Can cgroups help me in any way?

I can't use any sort of poll/select method. I need signals.

Thanks and regards
Mark
