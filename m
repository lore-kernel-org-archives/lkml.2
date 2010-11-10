Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab0KJLeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 06:34:00 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:60989 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab0KJLd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 06:33:58 -0500
Date: Wed, 10 Nov 2010 12:33:00 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jesper Juhl <jj@chaosbits.net>,
        "amd64-microcode@amd64.org" <amd64-microcode@amd64.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] microcode, AMD: Cleanup code a bit
Message-ID: <20101110113300.GA9518@aftab>
References: <20101102175248.GA25781@aftab>
 <20101110083121.GD3341@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110083121.GD3341@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 03:31:21AM -0500, Ingo Molnar wrote:
> Hm, what tree is this against - it doesnt apply here:

Ah, there's this one other patch that goes before that, sorry for not
mentioning it to you - I guess you still cannot read minds :-)

http://marc.info/?l=linux-kernel&m=128864852428104

Anyway, I've applied the two ontop of tip/x86/microcode and uploaded
them to

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tip-microcode


Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
