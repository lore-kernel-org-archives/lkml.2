Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0EQHdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 03:33:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62115 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab0EQHdP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 03:33:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C35hc7gJGLq7ZxhyQHlwQiB9FCfWINV3RHsL2D7DVryQ798T+MFcEdOFxH5iMyQ3Ui
         6FlsLnxfe3bONCNB10bFPOrjN55TVMVqU5LlmAJHAvqeqBwUzpdQ6kOhxURYbexfaV2u
         LIGwt+BAXiWYUHYnOwF023olN/XTeFRXmMqho=
MIME-Version: 1.0
In-Reply-To: <20100517160319.A195.A69D9226@jp.fujitsu.com>
References: <AANLkTikD7M_PKH3YgOWIvrcD6aW6X-gYIo2iw52QRRq_@mail.gmail.com>
	 <20100517160319.A195.A69D9226@jp.fujitsu.com>
Date: Mon, 17 May 2010 13:03:14 +0530
Message-ID: <AANLkTik2OcSBGdkRQKFl6xh06PEr7Al6xaUsmMGGC6jo@mail.gmail.com>
Subject: Re: Which function returns LWP in Linux.
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Srinivas Nayak <sinu.nayak2001@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello KOSAKI-san,

On Mon, May 17, 2010 at 12:33 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> Hi,
>>
>> For a process, we have different PIDs. For threads under a single
>> processes, we have different LWP id, but same PID in Linux.
>> ex.
>>
>> root@pc:/home/srinivas# ps -eLf
>> UID        PID  PPID     LWP  C STIME       TIME     CMD
>> root       100     1     100  0 May13       00:00:02 ./a.out
>> root       100     1     102  0 May13       00:00:00 ./a.out
>>
>> getpid() function returns PID of a process.
>> Which function retuns LWP id for thread?
>
> gettid()
>

gettid() is linux specific and not supported in glibc. Normally
application do not use gettid(), even procps is not using it, that why
I suggested Srinivas to check procps source to find the best solution
for it.

Thanks,
--
Jaswinder Singh.
