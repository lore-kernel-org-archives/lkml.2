Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab1C3Xwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 19:52:39 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46980 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab1C3Xwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 19:52:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UGg+kGcl3wtsqfTESog2t+GkE2UZy0Kj9LX6I0ss+Q8QmH2E43sJT9O6OYaeFVJjsL
         7AXMXuaYWWsjQaQkbhPYVmNsVKcfkxl4inPsUTzasi5riGS7yjEDdWnhrF4XQyigwCja
         oF5JpxXEa2DxRUZGleq+7gqFPW2FDTpwk0/RM=
Message-ID: <4D93C23F.9000009@gmail.com>
Date: Wed, 30 Mar 2011 16:52:31 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110316 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]arch:x86:kvm:i8254.h Fix typo in kvm_pit
References: <1301501942-3937-1-git-send-email-justinmattock@gmail.com> <4D9359CC.6050508@redhat.com> <4D935AC3.2030509@gmail.com> <4D93659F.2020900@redhat.com> <alpine.LNX.2.00.1103310019540.26754@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1103310019540.26754@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2011 03:21 PM, Jiri Kosina wrote:
> On Wed, 30 Mar 2011, Avi Kivity wrote:
>
>>>>> The below patch changes base_addresss to base_address.
>>>>> Note: I have grepped for base_addresss and nothing shows up,
>>>>> grepping for base_address gets me lots of output, telling me that
>>>>> this is a typo, but could be wrong.
>>>>>
>>>>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>>>
>>>>> ---
>>>>> arch/x86/kvm/i8254.h | 2 +-
>>>>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
>>>>> index 46d08ca..c2fa48b 100644
>>>>> --- a/arch/x86/kvm/i8254.h
>>>>> +++ b/arch/x86/kvm/i8254.h
>>>>> @@ -33,7 +33,7 @@ struct kvm_kpit_state {
>>>>> };
>>>>>
>>>>> struct kvm_pit {
>>>>> - unsigned long base_addresss;
>>>>> + unsigned long base_address;
>>>>> struct kvm_io_device dev;
>>>>> struct kvm_io_device speaker_dev;
>>>>> struct kvm *kvm;
>>>>
>>>> Why not remove the variable completely?
>>>>
>>>
>>> didnt even think to completely remove the variable(figured it was used
>>> somewhere).I will look at that and resend with removal of the variable for
>>> you..
>>
>> Well if it was used, you ought to have changed all of the users, no?
>
> I am afraid Justin is not trying to compile-test his patches (I got this
> suspicion after last patchset trying to remove all the includes of
> version.h).
>


I do remember to do that, but I will be honest there are ones that I 
totally forgot, then remembered after sending out the patch(I admit it I 
am guilty of that)

Think having a checklist is the best thing to follow when doing a patch
(telling yourself "yeah Ill remember to do that", never is the best way.

Justin P. Mattock
