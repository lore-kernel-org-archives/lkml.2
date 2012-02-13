Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab2BMJXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:23:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab2BMJXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:23:44 -0500
Message-ID: <4F38D694.4020905@redhat.com>
Date: Mon, 13 Feb 2012 07:23:32 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, bp@amd64.org,
        tony.luck@intel.com
Subject: Re: [PATCH v3 00/31] Hardware Events Report Mecanism (HERM)
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 09-02-2012 22:00, Mauro Carvalho Chehab escreveu:
> This is the third version of HERM patches.
> 

Forgot to mention, but I'm pushing the HERM patches on my edac tree on a
separate branch:

	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git hw_events

There are a few more patches there, as it can be seen via gitweb[1] that I'm
writing in order to fix bugs I'm noticing on my tests. I'll be merging/cleaning
the patches for a final version of this patchset after doing some tests on enough
systems to be sure that no regressions were introduced.

[1] http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=shortlog;h=refs/heads/hw_events

Regards,
Mauro
