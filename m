Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab0HBPt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:49:29 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38107 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab0HBPt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:49:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bOZulUAhcLcfKQ/bvhhDo/skzXnMxPjtW0UWWMIdxVONxGDdt4h8p4GB9V6WXoLtBK
         MNwIM9RXo1bcQjNvp9MqZh5PpbpNaAxqJc7a1HxZk1tk9QIRjai7T4H6FssVptbq5n0L
         V4tfja0WhMlv9hoPOC+EAXvNROkzsHd6xnLkM=
Message-ID: <4C56E914.2080905@gmail.com>
Date: Mon, 02 Aug 2010 08:49:40 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16462] unable to connect to AP on legal channels 12/13
References: <2dWFdr9kTFM.A.P0D.spXVMB@chimera>	<Aan7wZ97YaE.A.H2D.0pXVMB@chimera> <AANLkTikmgrKTLtgs1+h+BkS5X6qt9bP1wMDL4Gu7L3u3@mail.gmail.com>
In-Reply-To: <AANLkTikmgrKTLtgs1+h+BkS5X6qt9bP1wMDL4Gu7L3u3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 07:58 AM, Daniel J Blueman wrote:
> On 1 August 2010 14:52, Rafael J. Wysocki<rjw@sisk.pl>  wrote:
>> This message has been generated automatically as a part of a summary report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.34.  Please verify if it still should be listed and let the tracking team
>> know (either way).
>>
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16462
>> Subject         : unable to connect to AP on legal channels 12/13
>> Submitter       : Daniel J Blueman<daniel.blueman@gmail.com>
>> Date            : 2010-07-25 17:06 (8 days old)
>
> Yes, I just managed to reproduce this with 2.6.35-final, and will
> update the bugzilla entry with the wire-capture needed.


ahh.. cool.. lets get this bug fixed...

Justin P. Mattock
