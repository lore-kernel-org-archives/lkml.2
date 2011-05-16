Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab1EPXLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 19:11:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56121 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab1EPXLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 19:11:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=P7RHhe+zl8cWsUk7S7v+zxeIdJqav4B7kuvNiYUUo6otja19CTOcwbjAa/1QQhsycU
         nF8eQZP5NSPT/y+35brXus9sRc0/wJsPWyZ2SGFOD97XqvQFst6hcQvj2XN3c3rPZ5QK
         eh7dxUvtfmxcv905Hxze97fdeU+zO1lihfzh4=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "David Rientjes" <rientjes@google.com>,
        "Andy Whitcroft" <apw@canonical.com>, "Joe Perches" <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "John Stultz" <john.stultz@linaro.org>, "Ted Ts'o" <tytso@mit.edu>,
        "Jiri Slaby" <jirislaby@gmail.com>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>,
        "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] checkpatch.pl: Add check for task comm references
References: <1305580757-13175-1-git-send-email-john.stultz@linaro.org>
 <1305580757-13175-4-git-send-email-john.stultz@linaro.org>
 <op.vvlfaobx3l0zgt@mnazarewicz-glaptop>
 <alpine.DEB.2.00.1105161431550.4353@chino.kir.corp.google.com>
 <1305587090.2503.42.camel@Joe-Laptop>
Date: Tue, 17 May 2011 01:11:45 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vvlj1vad3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1305587090.2503.42.camel@Joe-Laptop>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011 01:04:50 +0200, Joe Perches <joe@perches.com> wrote:

> On Mon, 2011-05-16 at 14:34 -0700, David Rientjes wrote:
>> On Mon, 16 May 2011, Michal Nazarewicz wrote:
>> > > Now that accessing current->comm needs to be protected,
>> > > +# check for current->comm usage
>> > > +		if ($line =~ /\b(?:current|task|tsk|t)\s*->\s*comm\b/) {
>> > Not a checkpatch.pl expert but as far as I'm concerned, that looks  
>> reasonable.
>
> I think the only checkpatch expert is Andy Whitcroft.
>
> You don't need (?: just (

Yep, it's a micro-optimisation though.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
