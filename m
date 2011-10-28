Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab1J1UAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 16:00:04 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55009 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab1J1UAC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 16:00:02 -0400
MIME-Version: 1.0
In-Reply-To: <201110272206.35180.rjw@sisk.pl>
References: <201106260054.20578.rjw@sisk.pl>
	<201106292334.24518.rjw@sisk.pl>
	<CAKnu2Mru4c-2LBCZ_k3ZA+v47u0+um8igYU7EWt8=qOTVgcUjA@mail.gmail.com>
	<201110272206.35180.rjw@sisk.pl>
Date: Fri, 28 Oct 2011 22:00:01 +0200
Message-ID: <CACRpkdahSR0P-hSSJWqhouAn8KwdH-=Tsgg9K0sjeT_JAtDzVg@mail.gmail.com>
Subject: Re: [PATCH 4/6 v2] PM: Limit race conditions between runtime PM and
 system sleep (v2)
From: Linus Walleij <linus.walleij@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        linux-scsi@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        stable@kernel.org, Ulf Hansson <Ulf.Hansson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 10:06 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

>> We are trying to produce
>> a runtime PM system of product quality based on 3.0.y and we've
>> already had to backport this patch ourselves to get things stable.
>>
>> We have also backported:
>> PM: Introduce generic "noirq" callback routines for subsystems (v2)
>> PM / Runtime: Update documentation of interactions with system sleep
>> PM / Runtime: Add new helper function: pm_runtime_status_suspended()
>>
>> And now it seems to be sufficient to get this thing going.
>
> Well, it isn't a simple fix and it changes the code's behavior quite
> significantly, so I thought it might not be a good idea to risk problems
> with -stable because of it.  Perhaps let's see how it works out in 3.1
> and backport it later if there are no problem reports related to it?

OK no hurries, let's give it a spin in 3.1 for some weeks or so.

Yours,
Linus Walleij
