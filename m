Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab1LHKFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 05:05:49 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64886 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab1LHKFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 05:05:47 -0500
MIME-Version: 1.0
In-Reply-To: <20111208100204.GA31434@oksana.dev.rtsoft.ru>
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
	<20111208100204.GA31434@oksana.dev.rtsoft.ru>
Date: Thu, 8 Dec 2011 10:05:46 +0000
Message-ID: <CAD2FfiF5iPDhqQmvvS82xkuCh_HSeFJtPMBQdRuCCfz-9F6AFg@mail.gmail.com>
Subject: Re: [GIT PULL] power_supply: add power supply scope
From: Richard Hughes <hughsient@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Nicoletti <dantti12@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, vojtech@ucw.cz,
        Przemo Firszt <przemo@firszt.eu>, Richard Hughes <richard@hughsie.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 December 2011 10:02, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> I see one problem with this approach. Userland will need patching
> to distinguish system and device power supplies. So, even with
> the patch applied, old userland will behave incorrectly.

Userland will need patching anyway, as old versions of upower assumed
anything showing up in /sys/class/power_supply was powering the
system.

Richard.
