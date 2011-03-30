Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab1C3QbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:31:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50677 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab1C3QbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:31:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Zwn16UtZLsyAxA2lgrRe76fABhIcuhwD5QghBp/2InDhsNZnDGmFVYkyjyFLorM0m1
         tNI7y0nQPNdkjf24ZOkT8xtachkS+dyKU9rtaXkLYtDt8RTLTBTBlP34jylHYUHfkSac
         fnSRLp9b/8Dv3Sf2+Y8t1LkMp7wtJHMp1w890=
Message-ID: <4D935AC3.2030509@gmail.com>
Date: Wed, 30 Mar 2011 09:30:59 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110316 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: trivial@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]arch:x86:kvm:i8254.h Fix typo in kvm_pit
References: <1301501942-3937-1-git-send-email-justinmattock@gmail.com> <4D9359CC.6050508@redhat.com>
In-Reply-To: <4D9359CC.6050508@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2011 09:26 AM, Avi Kivity wrote:
> On 03/30/2011 06:19 PM, Justin P. Mattock wrote:
>> The below patch changes base_addresss to base_address.
>> Note: I have grepped for base_addresss and nothing shows up,
>> grepping for base_address gets me lots of output, telling me that
>> this is a typo, but could be wrong.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>> arch/x86/kvm/i8254.h | 2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
>> index 46d08ca..c2fa48b 100644
>> --- a/arch/x86/kvm/i8254.h
>> +++ b/arch/x86/kvm/i8254.h
>> @@ -33,7 +33,7 @@ struct kvm_kpit_state {
>> };
>>
>> struct kvm_pit {
>> - unsigned long base_addresss;
>> + unsigned long base_address;
>> struct kvm_io_device dev;
>> struct kvm_io_device speaker_dev;
>> struct kvm *kvm;
>
> Why not remove the variable completely?
>

didnt even think to completely remove the variable(figured it was used 
somewhere).I will look at that and resend with removal of the variable 
for you..

Justin P. Mattock
