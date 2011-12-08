Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab1LHKCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 05:02:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38302 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1LHKCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 05:02:30 -0500
Date: Thu, 8 Dec 2011 14:02:24 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Hughes <hughsient@gmail.com>,
        Daniel Nicoletti <dantti12@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, vojtech@ucw.cz,
        Przemo Firszt <przemo@firszt.eu>, Richard Hughes <richard@hughsie.com>
Subject: Re: [GIT PULL] power_supply: add power supply scope
Message-ID: <20111208100204.GA31434@oksana.dev.rtsoft.ru>
References: <CACo8zOd45i3EnCVMyJoDPP4bx2AnD9mEjDiC=bJKvmX=TWfXGg@mail.gmail.com>
 <4ED90E6D.8090402@goop.org>
 <CACo8zOcvKwr0wDkytvJfqyx4kV0ceYyCt+qnDqiSgxNywpzeHg@mail.gmail.com>
 <4ED9BDF8.3010600@goop.org>
 <CAD2FfiE-rg-1bMmVpYzBhnQcBMKKKO4WPnu0bvx+pvdFnpARrQ@mail.gmail.com>
 <4EDE4C7A.1010802@goop.org>
 <CAD2FfiHWuEmVTa54YqfJDk5zHpSQuM_nwPT=mR6NoWpajpydpg@mail.gmail.com>
 <4EDFA192.7000602@goop.org>
 <CAD2FfiF+fVoLPWpPyGGKdnoGhx1f=Loh2Ju-vdU58Y=2kf6C3g@mail.gmail.com>
 <4EE015D1.5070005@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4EE015D1.5070005@goop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jeremy,

On Wed, Dec 07, 2011 at 05:41:37PM -0800, Jeremy Fitzhardinge wrote:
> This series adds a "scope" property to power supplies, so that a power
> supply can indicate whether it powers the whole system, or just a
> device.  This allows upowerd to distinguish between actual system power
> supplies, and self-powered devices such as wireless mice.

I see one problem with this approach. Userland will need patching
to distinguish system and device power supplies. So, even with
the patch applied, old userland will behave incorrectly.

So, instead of the new 'scope' property, how about adding another
power supply type? I.e. DEVICE_BATTERY ? That type would be unknown
to the current userland, and thus should be ignored.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
