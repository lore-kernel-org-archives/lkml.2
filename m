Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab1BDXOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 18:14:42 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:50129 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582Ab1BDXOl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 18:14:41 -0500
MIME-Version: 1.0
In-Reply-To: <20110204211032.GA14525@kroah.com>
References: <1296591184-31554-1-git-send-email-omar.ramirez@ti.com>
	<20110204211032.GA14525@kroah.com>
Date: Fri, 4 Feb 2011 17:14:39 -0600
Message-ID: <AANLkTi=dWy4hFPVLAvx=6LDdO9dMoXBQzDS-X8LY2mBi@mail.gmail.com>
Subject: Re: [GIT PULL] staging: tidspbridge for 2.6.39
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel <devel@driverdev.osuosl.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Feb 4, 2011 at 3:10 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Feb 01, 2011 at 02:13:04PM -0600, Omar Ramirez Luna wrote:
>> The following changes since commit c56eb8fb6dccb83d9fe62fd4dc00c834de9bc470:
>>
>>   Linux 2.6.38-rc1 (2011-01-18 15:14:02 -0800)
>>
>> are available in the git repository at:
>>   git://dev.omapzoom.org/pub/scm/tidspbridge/kernel-dspbridge.git tidspbridge-for-2.6.39
>>
...
>>  86 files changed, 3028 insertions(+), 5297 deletions(-)
>
> Something's wrong here, I got:
>
>  86 files changed, 3009 insertions(+), 5272 deletions(-)
>
> I do have:
> [diff]
>        renamelimit=0
>
> in my .gitconfig file which might cause a difference if you are renaming
> stuff.
>
> Or did you add other patches to this tree that you didn't tell me about?

This is caused by the 2 patches included in staging-linus that were
not present in your staging-next (since it was on rc1), now that
staging-next moved to rc3, those patches were not picked from my
branch in the diffstat.

I get the same number of changes by excluding these two (already
present in mainline):
- staging tidspbridge: replace mbox callback with notifier_call
- staging: tidspbridge: configure full L1 MMU range

In my branch:

$ git diff --stat f06cba0018ddcd5d8f10fe576a7b853bc6ae2cf8 HEAD
...
86 files changed, 3009 insertions(+), 5272 deletions(-)

> I'll drop this pull for now until this gets sorted out.

Let me know if you can pull this or you want me to rebase to rc3.

Regards,

Omar
