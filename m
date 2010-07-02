Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab0GBA6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 20:58:43 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50400 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab0GBA6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 20:58:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Vsy67mob7RiQqCZWDyz8ieSUMWYVOulRsb7Kw3AvQfIkDrmWeunTveoSyhpTMlJ62s
         UFeOXCDStwAd5blyNY4EhEafXJSCfA5ezLZ+5fV29GHdtQabX7yfFkEJCfG4E7z7Ln1F
         LR7K8mC3Fop7VuuBI2ezoDpvp0dhgPz5k7XC0=
Message-ID: <4C2D39DD.6010305@gmail.com>
Date: Thu, 01 Jul 2010 17:59:09 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 3/5]acpi:glue.c Fix warning: variable 'ret' set but not
 used
References: <4C2CF400.20507@gmail.com> <4C2B9F49.8090304@gmail.com> <4C2A6B6C.1000306@gmail.com> <4C29674C.9070503@gmail.com> <4C28E14D.5050701@gmail.com> <1277621246-10960-4-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com> <7214.1277729293@redhat.com> <8066.1277750854@redhat.com> <22319.1277826461@redhat.com> <25800.1277889215@redhat.com> <16513.1277976706@redhat.com> <19422.1278029445@redhat.com>
In-Reply-To: <19422.1278029445@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2010 05:10 PM, David Howells wrote:
> Justin P. Mattock<justinmattock@gmail.com>  wrote:
>
>> a bit confused with the whole:  "?:" though
>> *condition ? value if true : value if false* (what if both are true
>> what if both are false or does it matter?)
>
> If you say:
>
> 	cond ?: false_value
>
> then you'll get cond if cond is non-zero and false_value if it isn't.
>
> I suspect it's a gccism.
>
> David
>

I'll have to experiment with this one..
?:

Justin P. Mattock
