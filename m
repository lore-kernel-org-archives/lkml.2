Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1CKDl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 22:41:29 -0500
Received: from linux-sh.org ([111.68.239.195]:56669 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab1CKDl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 22:41:26 -0500
Date: Fri, 11 Mar 2011 12:40:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Renninger <trenn@suse.de>
Cc: lenb@kernel.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] shmobile: Rename cpuidle states to fit to general conventions
Message-ID: <20110311034035.GC8065@linux-sh.org>
References: <1298842606-55712-1-git-send-email-trenn@suse.de> <1298842606-55712-2-git-send-email-trenn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298842606-55712-2-git-send-email-trenn@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 10:36:42PM +0100, Thomas Renninger wrote:
> C0 is known as "busy", "not idle" state.
> X86 "busy polling" state also got renamed from C0
> to "POLL" recently.
> Let's stay consistent with naming to avoid confusions.
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> Acked-by: Magnus Damm <damm@opensource.se>
> CC: linux-sh@vger.kernel.org

Fine with me. Applied, thanks.
