Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab2ENV4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:56:07 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:47051 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758094Ab2ENV4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:56:03 -0400
Date: Mon, 14 May 2012 23:55:46 +0200
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] x86/mce: Only restart instruction after machine
 check recovery if it is safe
Message-ID: <20120514215546.GA23488@aftab.osrc.amd.com>
References: <cover.1336674796.git.tony.luck@intel.com>
 <e6fa674d2f4ded80201f733d06b234b21559f0fe.1336674796.git.tony.luck@intel.com>
 <20120513095913.GB28863@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192EED2B@ORSMSX104.amr.corp.intel.com>
 <20120514171702.GC21960@aftab.osrc.amd.com>
 <CA+8MBbKr-dc2MFNCvthqWzy3MvQmb8UEKy74mi36BkYHLDTOPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbKr-dc2MFNCvthqWzy3MvQmb8UEKy74mi36BkYHLDTOPg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 11:02:59AM -0700, Tony Luck wrote:
> On Mon, May 14, 2012 at 10:17 AM, Borislav Petkov <bp@amd64.org> wrote:
> > I was wondering about that but don't have any other flags/use cases.
> > Well, we can always change it later if needed.
> 
> So is that an Ack? I was thinking that I should send this part to
> Linus now ... since restarting from a fault when RIPV isn't set
> could result in an application doing something bad (like getting
> the wrong answer).

Yep, sure.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
