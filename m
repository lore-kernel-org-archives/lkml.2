Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1AQSWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 13:22:46 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37097 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab1AQSWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 13:22:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BEL9+svBbwF44fcrGvTg7CafLrMiNOqhrdsgythUCqoRGTQ628NOXIJu8YJAS1uU18
         L4RM1LTJ+I6InuRvMcC8HEOKGke0YmXFyuLeNwxb01IBEOMwE9ML4aTRf0g6JZDulKk0
         jKfmI2DNhsQbgmzIXcJ1zcjuTlVGY3Y4T0meY=
Message-ID: <4D34876C.7020702@gmail.com>
Date: Mon, 17 Jan 2011 19:16:12 +0100
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf-record: auto detect when stdout is a pipe
References: <m3ipxo966i.fsf@gmail.com> <20110117172747.GD2085@ghostprotocols.net>
In-Reply-To: <20110117172747.GD2085@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2011 06:27 PM, Arnaldo Carvalho de Melo wrote:
> Em Sun, Jan 16, 2011 at 05:14:45PM +0100, Franck Bui-Huu escreveu:
>> From: Franck Bui-Huu <fbuihuu@gmail.com>
>>
>> This patch gives the ability to perf-record to detect when its stdout
>> has been redirected to a pipe. There's now no more need to add '-o -'
>> switch in this case.
>>
>> However '-o <path>' option has always precedence, that is if specified
>> and stdout has been connected via a pipe then the output will go into
>> the specified output.
>>
> 
> I guess we could have that in perf report as well? I.e. if stdin is a
> FIFO...
> 

Yes, I noticed that too, perf-script is also a candidate.

I'll do.

		Franck
