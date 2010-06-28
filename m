Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab0F1Rtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 13:49:39 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:32772 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab0F1Rtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 13:49:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Apzjt4G3qMxxhzijreQ6h5Gz+qNBRIj03PR8ujQALg39uMIWsUSCSutb1WgedWGziE
         n4dAjwhcRfEyPtOwK4xU6P9HvfUdLAF86IZjWfhTd3oFp1eHng/CTerJC2rIWKd/eN1A
         s2P8OntMGtfOtFU6+iEUIdsEwLMJeNPG8jDNg=
Message-ID: <4C28E0BF.6020700@gmail.com>
Date: Mon, 28 Jun 2010 10:49:51 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, lenb@kernel.org,
       linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 2/5]security:ebitmap.c Fix warning: variable 'e_sft' set
 but not used
References: <1277621246-10960-3-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com> <7140.1277729043@redhat.com>
In-Reply-To: <7140.1277729043@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 05:44 AM, David Howells wrote:
> Justin P. Mattock<justinmattock@gmail.com>  wrote:
>
>> gcc is giving me this during compiling:
>>    CC      security/selinux/ss/ebitmap.o
>> security/selinux/ss/ebitmap.c: In function 'ebitmap_netlbl_import':
>> security/selinux/ss/ebitmap.c:159:27: warning: variable 'e_sft' set but not used
>>
>> The below fixes this warning for me.
>> (please check this whenever you have time).
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>
> Acked-by: David Howells<dhowells@redhat.com>
>
> (though I wonder if e_sft should be used for something...)
>

alright..

Justin P. Mattock
