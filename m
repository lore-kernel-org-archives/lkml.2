Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1ECLXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 07:23:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37254 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752019Ab1ECLXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 07:23:52 -0400
Date: Tue, 3 May 2011 12:23:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: tiwai@suse.de, perex@perex.cz, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, lrg@slimlogic.co.uk
Subject: Re: [PATCH] SOC: UDA134x: Enable POWER_OFF_ON_STANDBY define.
Message-ID: <20110503112350.GG1762@opensource.wolfsonmicro.com>
References: <1304415149-19725-1-git-send-email-marek.belisko@open-nandra.com>
 <20110503100042.GA1762@opensource.wolfsonmicro.com>
 <BANLkTimE_TEzManZb2McLnohqbc27hRZ=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimE_TEzManZb2McLnohqbc27hRZ=w@mail.gmail.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 01:09:27PM +0200, Belisko Marek wrote:
> On Tue, May 3, 2011 at 12:00 PM, Mark Brown

> > If this is essential why is it optional in the first place?

> Not sure about background. Maybe whole define should be removed

That's exactly what I'm suggesting.

> This change was introduced in commit:f0fba2ad

*Always* include a plain text description of the commit for those of us
who haven't memorised the entire git history.  In this case I suspect
you need to do a bit more digging, that commit will just have done some
code motion here.
