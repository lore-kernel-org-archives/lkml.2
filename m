Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab0HIWYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 18:24:11 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48097 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab0HIWYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 18:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=s0YqziBNIWtyzTHXCrII1A6/RxHLSNI6a7WGTcvgvFRGyeCuK1QXT9dU4nVzHsolSw
         wZp3FUSW4TxkihG0DC5swmpmwZmD8F7Me33qk/iqAsF91v1h8Q7mAovo/aevnhV4vq74
         z4e9evRtwteAuQKxNHAf0wiXshyCPDgpF7DF8=
Message-ID: <4C60801C.1080605@gmail.com>
Date: Mon, 09 Aug 2010 15:24:28 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Valeo de Vries <valeo@valeo.co.cc>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Query: Patches break with Microsoft exchange server.
References: <4C5F9B25.8080401@st.com>	<201008091735.11105.mihai.dontu@gmail.com>	<4C6040FC.2020702@gmail.com>	<201008092115.25992.mihai.dontu@gmail.com>	<1281389338.7143.32.camel@localhost>	<4C607998.90509@gmail.com> <AANLkTimVMUvJLG2N5dPYAHpw8wyLdQpYaUF+F4Trw8eb@mail.gmail.com>
In-Reply-To: <AANLkTimVMUvJLG2N5dPYAHpw8wyLdQpYaUF+F4Trw8eb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2010 03:12 PM, Valeo de Vries wrote:
> On 9 August 2010 22:56, Justin P. Mattock<justinmattock@gmail.com>  wrote:
>> On 08/09/2010 02:28 PM, David Woodhouse wrote:
>>>
>>> On Mon, 2010-08-09 at 21:15 +0300, Mihai Donțu wrote:
>>>>
>>>> Wait. I don't think we're on the same page here. I'm talking about
>>>> message
>>>> signing (which does not require the receiving end to have any key - it's
>>>> the
>>>> same plain text e-mail with a blob after it) while you refer to actually
>>>> encrypting the message. Mm? Or am I being extremely slow today? :-)
>>>
>>> Only when you assume that Exchange would pass signed messages without
>>> corrupting them. It really is that broken.
>>>
>>
>> figured the encryption would be kind of a last resort situation..but if it's
>> that broken to where it wont pass it along without corrupting, then the best
>> solution is to figure out what Microsoft needs in terms of encoding, i.e. is
>> there a way to have the scanner scan but not throw everything around after
>> it scans.(if this is what it's doing)
>
> The link I posted earlier seems to give the impression that
> quoted-printable might do that. I may have misread that, though...
>
> Valeo
>


make sense.. Im wondering if it's a simple tell microsoft to scan the 
original email, take the garbled copied email and send out the original 
email rather than updating exchange etc...

Justin P. Mattock
