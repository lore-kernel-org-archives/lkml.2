Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab1LIJ7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 04:59:32 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36056 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1LIJ7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 04:59:31 -0500
Date: Fri, 9 Dec 2011 13:59:25 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Hughes <hughsient@gmail.com>,
        Daniel Nicoletti <dantti12@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, vojtech@ucw.cz,
        Przemo Firszt <przemo@firszt.eu>, Richard Hughes <richard@hughsie.com>
Subject: Re: [GIT PULL] power_supply: add power supply scope
Message-ID: <20111209095925.GA19883@oksana.dev.rtsoft.ru>
References: <CAD2FfiE-rg-1bMmVpYzBhnQcBMKKKO4WPnu0bvx+pvdFnpARrQ@mail.gmail.com>
 <4EDE4C7A.1010802@goop.org>
 <CAD2FfiHWuEmVTa54YqfJDk5zHpSQuM_nwPT=mR6NoWpajpydpg@mail.gmail.com>
 <4EDFA192.7000602@goop.org>
 <CAD2FfiF+fVoLPWpPyGGKdnoGhx1f=Loh2Ju-vdU58Y=2kf6C3g@mail.gmail.com>
 <4EE015D1.5070005@goop.org>
 <20111208104127.GA1753@oksana.dev.rtsoft.ru>
 <4EE0EB7B.6060807@goop.org>
 <20111208233643.GA19022@oksana.dev.rtsoft.ru>
 <4EE1C467.9050607@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4EE1C467.9050607@goop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 12:18:47AM -0800, Jeremy Fitzhardinge wrote:
> On 12/08/2011 03:36 PM, Anton Vorontsov wrote:
> >
> > No different at all, I'm fine with either power_supply.scope or any
> > other flag. :-)
> 
> So are you happy to pull that branch, or did you have some other
> concerns with it?

I'm OK w/ the idea itself, but to actually pull that branch, the issue
w/ needless patching of battery drivers has to be fixed (i.e. drop the
changes in the drivers/acpi/).

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
