Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab0IMReY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:34:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37501 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab0IMReW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:34:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=h0pWEGpAh8rcLHK05aQpKel/i7/Tki4SuFnPx42DGZGNLxNyviiVabuRKZMOa6kec8
         Jywk3UYp2hlm37A38ylN85glVG8ueEnIoTIQn2hUErGehVMdvgo4mlmmchDFFxaAhPB+
         DhoVLhI6RDamLwSBSMtYIi+8yiThUTedatFf8=
Message-ID: <4C8E60C7.2050208@gmail.com>
Date: Mon, 13 Sep 2010 10:35:03 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]scripts/kconfig/gconf.glade Update broken web addresses.
References: <1284184584-8647-1-git-send-email-justinmattock@gmail.com> <4C8E49C8.6090003@suse.cz>
In-Reply-To: <4C8E49C8.6090003@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 08:56 AM, Michal Marek wrote:
> On 11.9.2010 07:56, Justin P. Mattock wrote:
>> Below fixes a broken web address. Note: not sure if this is correct
>> or not.. Let me know..
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   scripts/kconfig/gconf.glade |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/scripts/kconfig/gconf.glade b/scripts/kconfig/gconf.glade
>> index d52b0a7..8092dcf 100644
>> --- a/scripts/kconfig/gconf.glade
>> +++ b/scripts/kconfig/gconf.glade
>> @@ -1,5 +1,5 @@
>>   <?xml version="1.0" standalone="no"?>  <!--*- mode: xml -*-->
>> -<!DOCTYPE glade-interface SYSTEM "http://glade.gnome.org/glade-2.0.dtd">
>> +<!DOCTYPE glade-interface SYSTEM "http://library.gnome.org/devel/libglade/unstable/libglade-dtd.html">
>
> This URL does not host the dtd itself, so we can as well remove the
> DOCTYPE declaration alltogether. I guess libglade validates the file
> against it's own schema anyway.
>
> Michal
>


o.k...

Justin P. Mattock
