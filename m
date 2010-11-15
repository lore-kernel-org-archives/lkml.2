Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab0KOQpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 11:45:01 -0500
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:42071 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757452Ab0KOQpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 11:45:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cR/ePrehc3JwtA6zYMBESYg2YHaTcfZ6wRZmoMV6fdeAWlaraQGogGOUpDkbpNZTZHPATwD92/LFVzRorkMjmv9Y0WSi8YPyEZLI4imo7J8YOnjsQsixEGbT6sjeUKhP;
Date: Mon, 15 Nov 2010 08:44:42 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Richard Purdie <rpurdie@rpsys.net>, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] Backlight: Add backlight type
Message-ID: <20101115084442.3ad2c6f9@jbarnes-desktop>
In-Reply-To: <20101115154820.GB21734@srcf.ucam.org>
References: <1283963539-4039-1-git-send-email-mjg@redhat.com>
	<20101115154820.GB21734@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010 15:48:20 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Richard, any feedback on this?
> 

At KS akpm said he'd likely be taking over backlight from Richard,
since Richard is very distracted with other things atm (please correct
me if I'm wrong).

So either someone needs to volunteer to maintain this subsystem (I know
how much you love backlights, maybe you'd like to do it?) or you need to
get this patch over to akpm.

-- 
Jesse Barnes, Intel Open Source Technology Center
