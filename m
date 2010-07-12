Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab0GLRm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:42:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64354 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab0GLRm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:42:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mk7vWZnrBepd8av8WDz78q/U+TVzPZ8ugu0T4uhQlHhXhOOQ529IiFAb904L8hn/nf
         sarXfeubzExJUAX3gTpT1CET3PpsIzTRSzbvvf22QrMMHlSjXaIOYP/mDFQxaj1rbTa2
         C0ozTHTsJEs2zSDXa4smfmVClo05FHYGCfw4U=
MIME-Version: 1.0
In-Reply-To: <20100712174114.GA17431@merkur.ravnborg.org>
References: <201007120554.16459.vda.linux@googlemail.com>
	<20100712100301.db1d3980.randy.dunlap@oracle.com>
	<AANLkTin88f83UV4HcqKtaXS7F2hMTe8YVJPpE-XLmo5J@mail.gmail.com>
	<20100712172847.GA17423@merkur.ravnborg.org>
	<AANLkTimTdQRCoWzCYZ7yBLYsKr4P812n8UR678hktJbO@mail.gmail.com>
	<20100712174114.GA17431@merkur.ravnborg.org>
Date: Mon, 12 Jul 2010 19:42:25 +0200
Message-ID: <AANLkTik8WV6kRwDK2N5M_hg7Opi0agLdIERK06GwhU0o@mail.gmail.com>
Subject: Re: Modpost error after changing CONFIG_SOUND from m to y
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 7:41 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> >
>> > What is the intial reason why you assign CFLAGS_KERNEL and CFLAGS_MODULE?
>>
>> I want to add some flags to every compiler invocation.
>
>    make KCFLAGS=-DMYSTUFF
>
> is what you want to use then.

What to do if I want different options for kernel and for modules?
-- 
vda
