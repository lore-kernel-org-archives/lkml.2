Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab2LWAmW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 19:42:22 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:37511 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab2LWAmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 19:42:18 -0500
MIME-Version: 1.0
In-Reply-To: <20121223002507.GA12121@liondog.tnic>
References: <20121222203547.GA5319@liondog.tnic>
	<CADnq5_MJzNdWVCauZj5Z7Monmsy4gWeYP3gJaPUPwHEgqhqOYw@mail.gmail.com>
	<20121223002507.GA12121@liondog.tnic>
Date: Sat, 22 Dec 2012 19:42:16 -0500
Message-ID: <CADnq5_Oe=_nOrsgUZvPc82F5CFAWecx=Uiqn0CAeK+YG3ns3AA@mail.gmail.com>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
From: Alex Deucher <alexdeucher@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 7:25 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Sat, Dec 22, 2012 at 07:01:31PM -0500, Alex Deucher wrote:
>> What chip is this?
>
> I think it is RV635. Here's the whole 3.8-rc1 dmesg.

Does booting with radeon.wb=0 help?

Alex
