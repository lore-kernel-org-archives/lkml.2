Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab0KBQKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:10:13 -0400
Received: from us-mx4.synaptics.com ([12.178.49.178]:28252 "EHLO
	us-mx4.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab0KBQKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:10:11 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Tue, 02 Nov 2010 06:15:12 -0800
Message-ID: <4CD03886.5030502@synaptics.com>
Date: Tue, 2 Nov 2010 09:12:54 -0700
From: Christopher Heiny <cheiny@synaptics.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Naveen Kumar G <naveen.gaddipati@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "STEricsson_nomadik_linux@list.st.com" 
	<STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCHv1] staging: Synaptics RMI4 touchpad driver support
References: <1288699725-14405-1-git-send-email-naveen.gaddipati@stericsson.com> <20101102140337.GC9387@kroah.com>
In-Reply-To: <20101102140337.GC9387@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2010 07:03 AM, Greg KH wrote:
> On Tue, Nov 02, 2010 at 05:38:45PM +0530, Naveen Kumar G wrote:
>> --- /dev/null
>> +++ b/drivers/staging/ste_rmi4/TODO
>> @@ -0,0 +1,7 @@
>> +TODO
>> +----
>> +
>> +Wait for the official upstream synaptics rmi4 clearpad drivers as promised over the past few months
>> +Merge any device support needed from this driver into it
>> +Delete this driver
>
> Huh?
>
> Why not just add this driver to the kernel tree instead?  When the
> "promised" driver then eventually shows up (who is promising it?) then
> delete the thing.

I (as technical lead for the kernel driver team at Synaptics) am 
promising it.

>
> But until then, why is this needed to go into the staging tree?  Is
> there any other main reason it should be here and not in the "real" part
> of the kernel?

Well, it's based off a patch that we submitted in August (or possibly 
before), that Dmitry did not find acceptable for the "real" part of the 
kernel.  He requested us to use kernel primitives for binding instead of 
rolling our own, which has led to an extensive refactoring of the code. 
  We're in internal code review of that factoring right now, and if we 
pass out of that, we'll submit a patch this week.

Dmitry did create a branch (synaptics-rmi4) in his git tree at 
kernel.org for this work, and applied our most recent patch to that 
branch (with some changes).

I must confess that I am seriously confused as to why this patch should 
be considered for fast tracking into the "real" kernel.  It's based on 
an implementation that wasn't considered suitable for the "real" kernel, 
and doesn't address the concerns relating to that.  If "merge it now, 
fix it later" wasn't an acceptable approach previously, is there some 
compelling reason it is now acceptable?

On the other hand, I totally understand frustration with our slow rate 
of output.  We're trying to produce the best possible code, but this is 
not happening as quickly as any of us would like.

						Chris

>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

