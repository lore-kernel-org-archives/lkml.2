Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab0FOF6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 01:58:45 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64251 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab0FOF6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 01:58:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=hYbRtG9TlQuImog4131T1J3cLvaXopg01vWCl8lRSMHd9V2BBJeibuOAY3uCkGtZnw
         o6CbwlbdaO2RLXHWhNHDAHSBGkmK599dgHrhnqi66Pm7Ky7jIdwFIZxvYQdlprWe4CD+
         E6liHcGNnn+fv068mistv6B5Ueu7mnPudxuQM=
Message-ID: <4C17169F.4060205@gmail.com>
Date: Mon, 14 Jun 2010 22:58:55 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       dri-devel@lists.freedesktop.org, reiserfs-devel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, debora@linux.vnet.ibm.com,
       linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 4/8]drivers:tmp.c Fix warning: variable 'rc' set but	not
 used
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-5-git-send-email-justinmattock@gmail.com> <21331.1276560832@localhost> <4C16E18F.9050901@gmail.com> <9275.1276573789@localhost> <4C16F9FC.2080905@gmail.com> <20100615052944.7746.qmail@stuge.se>
In-Reply-To: <20100615052944.7746.qmail@stuge.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 10:29 PM, Peter Stuge wrote:
> Justin P. Mattock wrote:
>>> *baffled* Why did you think that would work? transmit_cmd()s signature
>>> has 4 parameters.
>>
>> I have no manual in front of me. Did a quick google, but came up with
>> (no hits) info on what that function does. grep showed too many entries
>> to really see why/what this is.
>
> Check out the tool cscope. (Or kscope, if you prefer a GUI.)
>
>
> //Peter
>

thanks for this tool.. I think this is what I need.. running around not 
knowing what/where the manual is for a call is a bit daunting.
I'll give this a look.

Thanks for this..

Justin P. Mattock
