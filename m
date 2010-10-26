Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab0JZRIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:08:24 -0400
Received: from smtp.nokia.com ([147.243.1.47]:49054 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932298Ab0JZRIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:08:23 -0400
From: Felipe Contreras <felipe.contreras@nokia.com>
Subject: RE: [PATCH 1/8] staging: tidspbridge - remove req_addr from proc_map
To: fernando.lugo@ti.com, felipe.contreras@gmail.com
Cc: gregkh@suse.de, hiroshi.doyu@nokia.com, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <496565EC904933469F292DDA3F1663E602F49E280A@dlee06.ent.ti.com>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com> <1288054306-4361-2-git-send-email-x0095840@ti.com> <AANLkTimCDM_nruvh_gqxxy0CVnw2sH5UYNT9VgyeBfZN@mail.gmail.com> <496565EC904933469F292DDA3F1663E602F49E280A@dlee06.ent.ti.com>
User-Agent: notmuch 0.3.1-85-ge35d5aa
Message-ID: <1288112616-notmuch-felipe.contreras@nokia.com>
Date: Tue, 26 Oct 2010 20:07:57 +0300
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fernando.lugo@ti.com wrote:
> > On Tue, Oct 26, 2010 at 3:51 AM, Fernando Guzman Lugo 
> > <x0095840@ti.com> wrote:
> > > The device address is assigned by tidspbridge no need for 
> > that parameter anymore.
> > >
> > > Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> > 
> > This would break the API with user-space, right?
> 
> Yes, user-space needs to be changed accordingly.

Wouldn't it make sense to avoid stuffing so many changes at once
including ABI breakage?

Does user-space really _needs_ to be changed? Can't you just ignore that
argument?

> > I think this change should be delayed, preferably after we 
> > have a working tidspbridge.
> 
> The issue you were seeing must be fixed with patch 2/8, and
> Having all the dependencies tidspbridge has to be working
> Properly.

Yes, which might not happen at .37. If we revert the iommu stuff, we
might have a chance at having a working bridge on .37.

-- 
Felipe Contreras
