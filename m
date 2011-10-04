Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab1JDS1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 14:27:42 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:55808 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932752Ab1JDS1l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 14:27:41 -0400
MIME-Version: 1.0
In-Reply-To: <m2y5x0k40l.fsf@bob.laptop.org>
References: <1317750317-4489-1-git-send-email-linkinjeon@gmail.com>
 <CANfBPZ_aet5iF2zQ6zaqX0cjVB4LUnq6wLcHh2t_WNst3zXKAA@mail.gmail.com> <m2y5x0k40l.fsf@bob.laptop.org>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Tue, 4 Oct 2011 23:57:18 +0530
Message-ID: <CANfBPZ_ncmQmugQ+GBszE0OMvYV5T7W0Yo-dP5=JcoabNLaEeA@mail.gmail.com>
Subject: Re: [PATCH v10] mmc : general purpose partition support.
To: Chris Ball <cjb@laptop.org>
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, awarkentin@vmware.com,
        adrian.hunter@intel.com, linus.walleij@linaro.org,
        james_p_freyensee@linux.intel.com, sebras@gmail.com,
        Ulf.Hansson@stericsson.com, stefan.xk.nilsson@stericsson.com,
        per.forlin@stericsson.com, johan.rudholm@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 4, 2011 at 11:55 PM, Chris Ball <cjb@laptop.org> wrote:
> Hi,
>
> On Tue, Oct 04 2011, S, Venkatraman wrote:
>> Stupid question - This will affect all MMC instances, right ? Doesn't
>> this constitute a ABI breakage for user space scripts ?
>
> As I understand it, these partitions were simply not accessible before
> this patch:  we're not renaming mmcblkNpY to anything else, we're adding
> support for mmcblkNgpY partitions, which are part of the "MMC General
> Purpose Partition" spec, and are partitioned separately and not
> currently available to userspace.
>
> So, I don't see what would constitute breakage.  Does that clear it up?
>
It does - thanks !!
