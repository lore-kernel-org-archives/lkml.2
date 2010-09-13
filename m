Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab0IMOoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:44:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab0IMOon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:44:43 -0400
Message-ID: <4C8E3853.70702@redhat.com>
Date: Mon, 13 Sep 2010 10:42:27 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Make efifb check that the base address is plausible
 on pci systems.
References: <1284059809-9973-1-git-send-email-pjones@redhat.com> <20100910171406.bdb4d90d.akpm@linux-foundation.org>
In-Reply-To: <20100910171406.bdb4d90d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2010 08:14 PM, Andrew Morton wrote:
> On Thu,  9 Sep 2010 15:16:48 -0400
> Peter Jones <pjones@redhat.com> wrote:
> 
>> Some Apple machines have identical DMI data but different memory
>> configurations for the video. Given that, check that the address in our
>> table is actually within the range of a PCI BAR on a VGA deivce in the
>> machine.
>>
>> This also fixes up the return value from set_system(), which has
>> always been wrong, but never resulted in bad behavior since there's only
>> ever been one matching entry in the dmi table.
>>
>> This also adds me as the efifb maintainer, since I've effectively been
>> acting as such for quite some time.
> 
> And what is the impact (and importance) of this patch?  Make some
> people's Mac displays work, I'd be guessing?
> 

That's correct.

-- 
        Peter

Gravity is a habit that is hard to shake off.
		-- Pratchett

01234567890123456789012345678901234567890123456789012345678901234567890123456789
