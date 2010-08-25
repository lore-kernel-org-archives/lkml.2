Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab0HYDaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 23:30:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46365 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab0HYDa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 23:30:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=J1QZHHJDqCvdnkCt7MsHcqsZ/6YJyAsuDopi3wiJGHTsWSG/mInNUGaErbXVWlJtqB
         sjNTljae1WeRa1iP/n43O4CmVWMuGXmeVh9KcAIsKtYHrtuEoh/wTTrIj4CtcaTfSE6T
         Sll9BfLuybCKujHDKa3g2GhFHVX40TejOaGT8=
Message-ID: <4C748E4F.4040408@gmail.com>
Date: Wed, 25 Aug 2010 05:30:23 +0200
From: Roberto Oppedisano <roberto.oppedisano@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100819 Thunderbird/3.1.2
MIME-Version: 1.0
To: "Tomas M." <tmezzadra@gmail.com>
CC: Roberto Oppedisano <roberto.oppedisano@infracom.it>,
        Paul Rolland <rol@as2917.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35 suspend regression (bisected)
References: <4C4C9E40.7070209@infracom.it> <20100804083732.3d8dae69@tux.DEF.witbe.net> <4C59192F.3010304@infracom.it> <4C6071DC.3010100@gmail.com>
In-Reply-To: <4C6071DC.3010100@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Il 09/08/2010 23:23, Tomas M. ha scritto:
>
>> Hello Roland,
>>     I did reply on the same thread confirming that that's the same 
>> issue I was having and that the proposed workaround did work for me.
>> After some days of testing I'm observing sporadic lockup on resume 
>> (not in suspend as in my original report), but I think this is 
>> another issue.
>>
>
> something like this? https://bugzilla.kernel.org/show_bug.cgi?id=16396
Yes,
     this seems to match pretty well.

Kind regards.
R
