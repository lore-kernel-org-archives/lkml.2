Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab0JGVal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:30:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56985 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab0JGVai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U7xD0GBq0RzV24ShaQjkj562L+2eL0855WGkdoOlgRo347c5GFXFhNlqlsRa/qUMWw
         KF767JTZ9WAihxI7aTmpl3JftTta0gZxBm0GBJC3AnFLZflgrSI5Vmbe+NXWT4JcxBBK
         dT7Uot42QqEOAZWFYz8/2KANBRD+exR8+XE0s=
Date: Thu, 7 Oct 2010 14:30:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mario Limonciello <superm1@ubuntu.com>, Matthew Garrett <mjg@redhat.com>
Cc: Keng-Yu Lin <keng-yu.lin@canonical.com>, len.brown@intel.com,
        alan-jenkins@tuffmail.co.uk, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dell-laptop: Add hwswitch_only module parameter
Message-ID: <20101007213027.GA18628@core.coreip.homeip.net>
References: <1286422207-14248-1-git-send-email-keng-yu.lin@canonical.com>
 <20101007111510.GA19624@srcf.ucam.org>
 <AANLkTinus8SxbXt14qabXgpbFXF4U+uNoKA-=eDuOjmp@mail.gmail.com>
 <20101007133529.GA21782@srcf.ucam.org>
 <AANLkTi=kTQpTkCF6-DE+LdNLH_aki9bD9NPF0L2qRr=Q@mail.gmail.com>
 <20101007205049.GB32726@srcf.ucam.org>
 <AANLkTi=bj3T5hcX9r3j5kyEQkNb7PAZK948kcrx4R8tC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=bj3T5hcX9r3j5kyEQkNb7PAZK948kcrx4R8tC@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 03:53:37PM -0500, Mario Limonciello wrote:
> Hi Matthew:
> 
> On Thu, Oct 7, 2010 at 15:50, Matthew Garrett <mjg@redhat.com> wrote:
> > On Thu, Oct 07, 2010 at 03:49:05PM -0500, Mario Limonciello wrote:
> >> Hi Matthew:
> >> > Is the kernel able to unblock it under those circumstances?
> >>
> >> Manually running rfkill unblock will unblock it in this broken
> >> firmware scenario in question.
> >
> > So the issue is in the firmware's response to the keystroke? Ok. I'd
> > rather have a DMI list of the broken machines than a module parameter.
> 
> Yes the issue is the firmware's response to the keystroke.  The
> intention here is to individual submit machines in future patches as
> they're discovered.  The parameter's primary purpose is to assist in
> building the list.  If someone reports a bug with these symptoms, they
> can add the parameter to their kernel command line, and report if it
> helps them.  If it helps, their machine can be added to the DMI table.
> 

Mario, Matthew,

Since the fix is not essential for boot purposes can we keep module
parameter only (without adding DMI entries) and push the task of
properly setting the module parmeter to udev?

We have this strategy for bunch of input stuff (force release, keymap)
and I think it works better than dding more and more DMI quirks into
kernel itself.

Thanks.

-- 
Dmitry
