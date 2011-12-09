Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab1LITjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 14:39:33 -0500
Received: from claw.goop.org ([74.207.240.146]:35226 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab1LITjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 14:39:31 -0500
Message-ID: <4EE23E21.7090509@goop.org>
Date: Fri, 09 Dec 2011 08:58:09 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Hughes <hughsient@gmail.com>,
        Daniel Nicoletti <dantti12@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, vojtech@ucw.cz,
        Przemo Firszt <przemo@firszt.eu>, Richard Hughes <richard@hughsie.com>
Subject: Re: [GIT PULL] power_supply: add power supply scope
References: <CAD2FfiE-rg-1bMmVpYzBhnQcBMKKKO4WPnu0bvx+pvdFnpARrQ@mail.gmail.com> <4EDE4C7A.1010802@goop.org> <CAD2FfiHWuEmVTa54YqfJDk5zHpSQuM_nwPT=mR6NoWpajpydpg@mail.gmail.com> <4EDFA192.7000602@goop.org> <CAD2FfiF+fVoLPWpPyGGKdnoGhx1f=Loh2Ju-vdU58Y=2kf6C3g@mail.gmail.com> <4EE015D1.5070005@goop.org> <20111208104127.GA1753@oksana.dev.rtsoft.ru> <4EE0EB7B.6060807@goop.org> <20111208233643.GA19022@oksana.dev.rtsoft.ru> <4EE1C467.9050607@goop.org> <20111209095925.GA19883@oksana.dev.rtsoft.ru>
In-Reply-To: <20111209095925.GA19883@oksana.dev.rtsoft.ru>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2011 01:59 AM, Anton Vorontsov wrote:
> On Fri, Dec 09, 2011 at 12:18:47AM -0800, Jeremy Fitzhardinge wrote:
>> On 12/08/2011 03:36 PM, Anton Vorontsov wrote:
>>> No different at all, I'm fine with either power_supply.scope or any
>>> other flag. :-)
>> So are you happy to pull that branch, or did you have some other
>> concerns with it?
> I'm OK w/ the idea itself, but to actually pull that branch, the issue
> w/ needless patching of battery drivers has to be fixed (i.e. drop the
> changes in the drivers/acpi/).

OK, and just use the default System?  So only patch devices which are
actually self-powered?

    J
