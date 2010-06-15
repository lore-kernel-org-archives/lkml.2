Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0FOH1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:27:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54825 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab0FOH1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:27:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kQSe59mDMRL2/Kk3+gZ5kAnktT9PmVLaT8FbRF2xYkkS/LKBBthYEi0HZUqLd6g1EN
         oR7ria7DzwDcKff/eIDqTt30XalW0GNr5Iel8vUpFH6XPq8pSGTzJHP2IdNoqCGujtSH
         sJZD9vVolzFJTRQkd6lwHz3s0E+DmRb+uaJFg=
Message-ID: <4C172B73.6090609@gmail.com>
Date: Tue, 15 Jun 2010 00:27:47 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       Peter Stuge <peter@stuge.se>
Subject: Re: [PATCH 4/8]drivers:tmp.c Fix warning: variable 'rc' set but	not
 used
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-5-git-send-email-justinmattock@gmail.com> <21331.1276560832@localhost> <4C16E18F.9050901@gmail.com> <9275.1276573789@localhost> <4C16F9FC.2080905@gmail.com> <20100615052944.7746.qmail@stuge.se> <4C17169F.4060205@gmail.com> <4C17244D.7010806@s5r6.in-berlin.de>
In-Reply-To: <4C17244D.7010806@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 11:57 PM, Stefan Richter wrote:
> Justin P. Mattock wrote:
>> On 06/14/2010 10:29 PM, Peter Stuge wrote:
>>> Justin P. Mattock wrote:
>>>> I have no manual in front of me. Did a quick google, but came up with
>>>> (no hits) info on what that function does. grep showed too many entries
>>>> to really see why/what this is.
>>>
>>> Check out the tool cscope. (Or kscope, if you prefer a GUI.)
>>
>> thanks for this tool.. I think this is what I need.. running around not
>> knowing what/where the manual is for a call is a bit daunting.
>
> Similar to cscope/kscope but online:
> http://lxr.free-electrons.com/
> http://lxr.linux.no/linux
>
> E.g. http://lxr.free-electrons.com/ident?i=transmit_cmd

hmm.. yeah I use those guys a lot.. with grep also.. I think what might 
throw me off is things like def.orig = def.new then def.orig gets lost 
in the mix(or it's there, but the grep becomes gigantic in code 
results.) main thing I look for is googling "somedefinition linux man"
for some idea of what that function does.

Justin P. Mattock
