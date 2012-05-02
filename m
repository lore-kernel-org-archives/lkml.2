Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab2EBIdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 04:33:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49659 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab2EBIdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 04:33:10 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1205011300540.1856@pobox.suse.cz>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
	<alpine.LNX.2.00.1205011300540.1856@pobox.suse.cz>
Date: Wed, 2 May 2012 10:33:10 +0200
Message-ID: <CAN+gG=GGVFDgf_PkovS+_OX26LH0Q19_FwwkGP2pSwnoX4d_Ug@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] hid: Introduce device groups
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephane Chatty <chatty@enac.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 1, 2012 at 1:03 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 23 Apr 2012, Henrik Rydberg wrote:
>
>> Hi Jiri,
>>
>> Here is the third version of the extension to the device-driver
>> matching mechanism. AFAICT, there are no outstanding issues. I think
>> we are getting close. :-)
>
> I have now updated the 'might-rebase/autoloading' branch of git.hid tree
> (this is a rebasing branch, so simple pull will not work for you as a
> fast-forward, you'll have to delete and repull the branch).
>
> It's currently in a shape I would be okay to pushing out for -next and
> scheduling for next merge window, and I will do so tomorrow if nothing
> else pops up during testing or reviews.

Hi Jiri,

Well, I'm back in my lab this morning, and I'm testing your branch
against the different devices we have here. I'm observing a strange
problem: when connecting some devices, the first touch is always at
0,0. If I rmmod and insmod hid_multitouch it seems to work after....

I'm investigating this bug now. I'll tell you when I'm done. I still
don't now if it's related to Henrik's changes or 3.4-rc4.

Cheers,
Benjamin


>
> Thanks everybody, especially Henrik of course, for excellent work on this.
>
> --
> Jiri Kosina
> SUSE Labs
