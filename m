Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab0GJVSJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 17:18:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63015 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab0GJVSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 17:18:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fJpf7CrHe1ScgpXUvl+UDFhHZvw8ujME6o6p+Y1PsS1aHz5e7kDvWVdTGW4X5zMc2e
         O8/ffuxytXTnYSf7x5zpVsVzh8nJID3bLtioZbupR+QPafT05RKzCcDAU7VVfkKR7sm4
         99BxXnq08+bLD/Opzdf+XDg/0bTMGq53NWf7M=
MIME-Version: 1.0
In-Reply-To: <20100710210750.GC6615@lenovo>
References: <1278790820-1817-1-git-send-email-penberg@cs.helsinki.fi>
	<20100710210750.GC6615@lenovo>
Date: Sun, 11 Jul 2010 00:18:06 +0300
X-Google-Sender-Auth: GHACGocE1VNXxkfDjlh35j6wYfI
Message-ID: <AANLkTim1wgrOaz5rXV-Cea3IjcZejrsRrCO0AUkcrOv-@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Early-boot serial I/O support
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 11, 2010 at 12:07 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> @@ -203,6 +205,17 @@ static inline int isdigit(int ch)
>>       return (ch >= '0') && (ch <= '9');
>>  }
>>
>> +static inline int isxdigit(int ch)
>> +{
>> +     if (isdigit(ch))
>> +             return true;
>> +
>> +     if ((ch >= 'a') && (ch <= 'f'))
>> +             return true;
>> +
>> +     return (ch >= 'A') && (ch <= 'F');
>> +}
>> +
>
> I suspect it's supposed to be static inline *bool*, right?

Yes, but I followed 'isdigit' here for symmetry and it uses 'int'.

                       Pekka
