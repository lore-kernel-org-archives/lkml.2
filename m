Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab0IWJ0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 05:26:07 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57748 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab0IWJ0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 05:26:05 -0400
Message-ID: <4C9B1D22.20504@canonical.com>
Date: Thu, 23 Sep 2010 11:25:54 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Lightning/1.0b1 Thunderbird/3.0.8
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Josh Hill <joshua.hill@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, alan@redhat.com, stable@kernel.org,
        Matthew Garrett <mjg@redhat.com>, "Zhang, Rui" <rui.zhang@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [2.6.35-rc5] hp-wmi patch missed .35 merge window, requesting
 addition to next rc
References: <AANLkTimOVY+iOOMKhwFfX5Wcw1y_PcvoCCfEcjoPmj3J@mail.gmail.com> <20100921190816.e6ca6a72.akpm@linux-foundation.org> <201009231037.09097.trenn@suse.de>
In-Reply-To: <201009231037.09097.trenn@suse.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2010 10:37 AM, Thomas Renninger wrote:
> Hi,
> 
> I didn't know about this one.
> Can people please add me to CC list on hp-wmi specific bug
> reports (for existing and new ones), thanks.
> 
> On Wednesday 22 September 2010 04:08:16 Andrew Morton wrote:
>> (cc's added)
>> The suggestion is that mainline's
>> 751ae808f6b29803228609f51aa1ae057f5c576e ("x86 platform drivers: hp-wmi
>> Reorder event id processing") be backported into 2.6.35.x to fix the
>> post-2.6.32 regression described in
>> https://bugzilla.kernel.org/show_bug.cgi?id=15344
> Hmm, the bug is still in "open" state, there is no statement that anything
> is found yet fixing the issue.
> 
> Could you please update the bug report if you verified and are sure
> the patch helps.
> 
> The patch is a cleanup, has some functional change, but should
> do things correctly now. As long as no special case was handled
> by always calling:
> hp_wmi_get_entry_by_scancode(eventcode);
> even it was not a hotkey event, this is a straight forward fix and
> if no one else complains, you have my vote for adding this to
> stable kernel(s).
> 
> about:
>> if this patch doesn't make it into .35 my laptop
>> will be doing this for its (10.10) entire lifetime.
> Isn't Ubuntu following stable 2.6.35.X kernels and you would get this with
> an update if it's pushed into stable kernels?
> I expect they do follow and there is no need to hurry?
> 
Yes, we do follow 2.6.35.y updates at least for a few months after release. So
there should be no particular need to hurry. At least if it gets to Greg before
he stops caring about .35.

-Stefan

>      Thomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

