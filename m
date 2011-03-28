Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab1C1Qgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:36:32 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36196 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab1C1Qga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:36:30 -0400
Date: Mon, 28 Mar 2011 11:36:27 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] toshiba_acpi: Additional TOS1900 devices support
Message-ID: <20110328163627.GB24926@thinkpad-t410>
Mail-Followup-To: Azael Avalos <coproscefalo@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Garrett <mjg@redhat.com>
References: <AANLkTi=fjL0yxXWrDddafdBs7biJ326sXjaagTseVEVg@mail.gmail.com>
 <20110117190849.GB27245@core.coreip.homeip.net>
 <AANLkTindwH2X79vZTBHU04oomxqV=RchRVEwrDEcntVX@mail.gmail.com>
 <20110120074503.GD30522@core.coreip.homeip.net>
 <AANLkTi=zCbRx-gTxPAUfSXJV4bRV8-bk3TqV=etybu7y@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=zCbRx-gTxPAUfSXJV4bRV8-bk3TqV=etybu7y@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 09:12:54AM -0700, Azael Avalos wrote:
> Hi there,
> 
> Any updates on this patch?
> I just saw a git-pull request, but I haven't seen this patch merged (yet).
> 
> I have a slightly updated patch (with suspend/resume functions added
> to workaround some issues on some Toshiba Netbooks) with some
> testing done by Seth Forshee, just in case that I need to resend.

Since the updates include a bugfix for hotkeys not working on the NB305
after suspend, I'd vote in favor of submitting the updated version.

Cheers,
Seth
