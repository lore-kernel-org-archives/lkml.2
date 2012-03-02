Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab2CBOmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:42:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab2CBOmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:42:15 -0500
Message-ID: <4F50DC32.10400@redhat.com>
Date: Fri, 02 Mar 2012 11:41:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [RFC -v2 PATCH 0/3] RAS: Use MCE tracepoint for decoded MCEs
References: <1330698314-9863-1-git-send-email-bp@amd64.org>
In-Reply-To: <1330698314-9863-1-git-send-email-bp@amd64.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 02-03-2012 11:25, Borislav Petkov escreveu:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Hi,
> 
> here's a second version of the patchset with the buffer enlarging ripped
> out. 1/4 in the series could go in independently since it is a cleanup,
> I'll add it to a for-next testing branch if there are no objections.

It is premature to add patch 2 for -next, as there was no agreement about
the fields to be added for the tracepoint. 

Also, We'll need to coordinate how to merge patch 4, as the changes at
edac_mc.c will conflict with my changes there (even removing the tracepoint patch),
as the memory location based on row/channel there only works for amd64.
That's mainly the reason why I didn't merge my patch series yet at -next,
but, instead, stored it on a separate branch.

Mauro.
