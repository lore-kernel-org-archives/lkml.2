Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab0KJTYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:24:21 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57447 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab0KJTYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:24:19 -0500
Date: Wed, 10 Nov 2010 20:23:23 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH 01/12] EDAC, MCE: Select extended error code mask
Message-ID: <20101110192322.GC13539@aftab>
References: <1289415741-15000-1-git-send-email-bp@amd64.org>
 <1289415741-15000-2-git-send-email-bp@amd64.org>
 <987664A83D2D224EAE907B061CE93D5301649A7081@orsmsx505.amr.corp.intel.com>
 <987664A83D2D224EAE907B061CE93D5301649A708E@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301649A708E@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 02:15:48PM -0500, Luck, Tony wrote:
> > (MCi_STATUS[20:16]). Add a mask variable which default 0xf is overridden
> > on F15h.
> 
> I failed to read the "overridden" part ...
> Ignore the noise - I blame the cold medication I'm taking.

And yet it doesn't stop you from looking at my wobbly decoding stuff.
Wait a sec, shouldn't you be relaxing instead? Ah well, kernel people...

Thanks for looking into it.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
