Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030191Ab2CBOsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:48:20 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:49575 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2CBOsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:48:18 -0500
Date: Fri, 2 Mar 2012 15:48:00 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -v2 PATCH 0/3] RAS: Use MCE tracepoint for decoded MCEs
Message-ID: <20120302144800.GA10004@aftab>
References: <1330698314-9863-1-git-send-email-bp@amd64.org>
 <4F50DC32.10400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F50DC32.10400@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 11:41:54AM -0300, Mauro Carvalho Chehab wrote:
> It is premature to add patch 2 for -next, as there was no agreement about
> the fields to be added for the tracepoint.

This is yet another proof that you're not really reading my emails:

> > 1/4 in the series could go in independently since it is a cleanup,
> > I'll add it to a for-next testing branch if there are no objections.

This sentence clearly refers to patch 1/4, i.e. the first patch in the
series. So either make sure you've really understood what you've read
before replying or don't reply at all.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
