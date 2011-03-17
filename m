Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab1CQNbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 09:31:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:56082 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab1CQNbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 09:31:36 -0400
Message-ID: <4D820D35.600@suse.cz>
Date: Thu, 17 Mar 2011 14:31:33 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: matt mooney <mfm@muteddisk.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 00/27] update makefiles to use the newer flag variables
References: <cover.1295006561.git.mfm@muteddisk.com>	<20110317131508.GB30807@sepie.suse.cz> <AANLkTikiBgigwOkXbYpTqr-4ihVYrmYB49pvh7k2toLz@mail.gmail.com>
In-Reply-To: <AANLkTikiBgigwOkXbYpTqr-4ihVYrmYB49pvh7k2toLz@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.3.2011 14:19, Geert Uytterhoeven wrote:
> On Thu, Mar 17, 2011 at 14:15, Michal Marek <mmarek@suse.cz> wrote:
>> On Fri, Jan 14, 2011 at 06:12:23AM -0800, matt mooney wrote:
>>> These are the patches that never made their way into the linux-next tree.
>>> I have added all of the acks that came through.
> 
>>>   m68k: change to new flag variables
> 
>> I committed these to kbuild.2.6.git#trivial and will send a pull request
>> to Linus.
> 
> JFYI, the m68k one went in last night through the m68k tree.

I did a rebase onto linux-next and back, so that I don't duplicate
patches that have been picked up by subsystem maintainers already. This
is the resulting shortlog, m68k is not there:

matt mooney (25):
      kernel: change to new flag variable
      arm: change to new flag variables
      h8300: change to new flag variable
      ia64: change to new flag variables
      microblaze: change to new flag variable
      mips: change to new flag variable
      s390: change to new flag variable
      um: change to new flag variables
      xtensa: change to new flag variable
      fs: change to new flag variable
      char: change to new flag variable
      dma: change to new flag variable
      hwmon: change to new flag variable
      ide: change to new flag variable
      ieee802154: change to new flag variable
      isdn: change to new flag variable
      memstick: change to new flag variable
      message: change to new flag variable
      misc: change to new flag variable
      net: change to new flag variable
      pps: change to new flag variable
      rapidio: change to new flag variable
      rtc: change to new flag variable
      scsi: change to new flag variable
      video: change to new flag variable

I guess I should be more verbose than "thanks, applied" next time :).

Michal
