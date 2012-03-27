Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab2C0GqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 02:46:06 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55059 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab2C0GqF convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:2>);
	Tue, 27 Mar 2012 02:46:05 -0400
Message-Id: <4F717E7B020000780007B06E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 27 Mar 2012 07:46:51 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Michal Marek" <mmarek@suse.cz>
Cc: <rusty@rustcorp.com.au>, <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] modpost: fix ALL_INIT_DATA_SECTIONS
References: <4F588CD50200007800077112@nat28.tlf.novell.com>
 <20120326204143.GB10259@sepie.suse.cz>
In-Reply-To: <20120326204143.GB10259@sepie.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 26.03.12 at 22:41, Michal Marek <mmarek@suse.cz> wrote:
> On Thu, Mar 08, 2012 at 09:41:25AM +0000, Jan Beulich wrote:
>> This was lacking a comma between two supposed to be separate strings.
>> 
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>> 
>> ---
>>  scripts/mod/modpost.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> --- 3.3-rc6/scripts/mod/modpost.c
>> +++ 3.3-rc6-modpost-all-init-data/scripts/mod/modpost.c
>> @@ -849,7 +849,7 @@ static void check_section(const char *mo
>>  
>>  #define ALL_INIT_DATA_SECTIONS \
>>  	".init.setup$", ".init.rodata$", \
>> -	".devinit.rodata$", ".cpuinit.rodata$", ".meminit.rodata$" \
>> +	".devinit.rodata$", ".cpuinit.rodata$", ".meminit.rodata$", \
> 
> Applied to kbuild.git#kbuild with a Cc: stable. BTW, was it causing actual
> false positives to be reported?

No, I just noticed this in the context of a bigger (PCI related) patch
that so far I didn't get any reaction on from you (intending to resend
at some point).

Jan

