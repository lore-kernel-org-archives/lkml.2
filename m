Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab0IPOTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 10:19:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54082 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab0IPOTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 10:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tgFUvVkibaXXjPc0vMHEH6wQG6k/azwvCId803HozKfSgJRBlI7tzrqc/iSdL/otfV
         wa4f4b8OGb7sOvKK96giWpesqtX/xGAqFOKHzeBPJPu5TOUtOmwTKq5pgkjs9+mrICi9
         6CVz4lGAVG8XeMMTGiKdnLzKJss3zefLLkjWE=
MIME-Version: 1.0
In-Reply-To: <4C524F7A.20505@gmail.com>
References: <E1OefgE-0005vu-JN@tytso-glaptop>
	<4C524F7A.20505@gmail.com>
Date: Thu, 16 Sep 2010 07:19:50 -0700
Message-ID: <AANLkTinKCyUnpmGz_opU19nr2PmTELyZ7cP69jEdF_zW@mail.gmail.com>
Subject: Re: PSA: Please update your flash plugin!
From: Justin Mattock <justinmattock@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org,
        ksummit-2010-discuss@lists.linux-foundation.org, bharrosh@panasas.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 9:05 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> On 07/29/2010 07:50 PM, Theodore Ts'o wrote:
>>
>> This is a public service announcement --- if you are running Flash 10.0,
>> make sure you upgrade to 10.1.  Flash 10.0 has a horrible security
>> vulnerability:
>>
>>        http://www.adobe.com/support/security/bulletins/apsb10-14.html
>>
>> I have Google Analytics running on the ksummit2010 website, and in
>> addition to discovering that 59% used Firefox and 25% were using Chrome,
>> and that the most popular screen resolution was 1280x800 followed by
>> 1280x1024, etc. --- I also was able to find that while 59% were running
>> Flash 10.1, over 40% of the visitors to the ksummit2010 web site were
>> running a vulnerable version of Adobe flash, which has a remote code
>> execution vulerability.
>>
>> If you were visiting that site from your development system, which you
>> use to push changes to a subsystem maintianer, or even Linus, hopefully
>> I don't need to tell you what a bad idea it is to leave yourself open
>> and vulnerable like this.  (This particular security problem with Flash
>> has been announced for almost 2 months at this point!)
>>
>>                                                - Ted
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>

o.k. looks like the x86_64 people are not left out in the cold...:
http://labs.adobe.com/downloads/flashplayer10.html


-- 
Justin P. Mattock
