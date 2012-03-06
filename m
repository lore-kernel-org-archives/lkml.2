Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030925Ab2CFUBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 15:01:18 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50809 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030369Ab2CFUBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 15:01:16 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.204.10.72 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Wed, 7 Mar 2012 00:01:11 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-man@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] prctl: Add PR_SET_MM option description
Message-ID: <20120306200111.GM29367@moon>
References: <1330518197-12825-1-git-send-email-gorcunov@openvz.org>
 <1330518197-12825-2-git-send-email-gorcunov@openvz.org>
 <CAKgNAkiOY-p7duD_wfed_Tk8T8SR5r1JCTa=0ne3-VQ30mQE-g@mail.gmail.com>
 <20120306182210.GJ29367@moon>
 <CAKgNAkjejoxs43UVgAR+YW7JZ1btCpMr+=K4jrZz=Ktv-TnS8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkjejoxs43UVgAR+YW7JZ1btCpMr+=K4jrZz=Ktv-TnS8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 08:52:30AM +1300, Michael Kerrisk (man-pages) wrote:
...
> >
> > If you prefer to have it done earlier -- no problem, I'll cook
> > a patch today instead on top of everything we've already
> > merged into linux-next. What would you prefer?
> 
> It would make sense if the capability requirements were finalized
> before 3.3 is released. Changing them after 3.3 creates (at least a
> little) pain for userspace.
> 

OK. I'll update and send a patch out.

	Cyrill
