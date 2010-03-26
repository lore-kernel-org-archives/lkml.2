Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab0CZJn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 05:43:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:46448 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab0CZJn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 05:43:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=WchzwYHOvuIaBSHVGUCHuZjKGMzeol85AcADQ2f18gl8DDq9p8q6fj2bblfS6qna6n
         R387ni0S5rrkanHgaSCEdH0OyxHrY5WfUv/aiVMD2jRPCmjI8zmz1U3MnLbN/pQ5vscH
         mN1XAqdxT1umS0W52lkCMmdijCxoKZwHzNXwk=
Message-ID: <4BAC81BB.9030606@gmail.com>
Date: Fri, 26 Mar 2010 10:43:23 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-6.1 Thunderbird/3.1b1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [RFC 08/15] PM / Hibernate: add user module_ops
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <1269361063-3341-8-git-send-email-jslaby@suse.cz> <201003252307.15232.rjw@sisk.pl>
In-Reply-To: <201003252307.15232.rjw@sisk.pl>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2010 11:07 PM, Rafael J. Wysocki wrote:
> On Tuesday 23 March 2010, Jiri Slaby wrote:
>> Add sws_module_ops into /dev/snapshot user interface, so far only with
>> .storage_available. The structure will be shortly filled while converting
>> it to ops.
>>
>> Also, when using this interface, switch to the ops on open/release.
> 
> Quite frankly, I don't really understand the purpose of this change in this
> particular form.  It looks like it may be folded into one of the subsequent
> changes just fine.

Yup, maybe the single-change-per-patch approach was overzealous here.
Squashed to 09/15.

thanks,
-- 
js
