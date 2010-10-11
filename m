Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab0JKSk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 14:40:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63612 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab0JKSk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 14:40:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=twM4JHEVQM2bBBA9Hol2ThDh9x4hqnQOexoUE8z4vqEv91PT6JxXlrE2jC8fXWwhIr
         muVdrGVZ8PLTjrdCogqIi0ZIZApBytRbti7UUFLJf76vkNbNH82Cz61lhVY+bG8Jeb/b
         qUhUyKYl3mO32AtEMktFrmGZuF+BEYx7mMS9g=
MIME-Version: 1.0
In-Reply-To: <4CB34D55.6060007@logicpd.com>
References: <1285603550-6382-1-git-send-email-tim.nordell@logicpd.com>
	<20100928171908.GE3117@atomide.com>
	<201010090155.25932.linz@li-pro.net>
	<4CAFB747.5020606@logicpd.com>
	<20101011173023.GB25462@atomide.com>
	<4CB34D55.6060007@logicpd.com>
Date: Mon, 11 Oct 2010 14:40:51 -0400
Message-ID: <AANLkTikK6QAwj_T67NQAhVDT2T+D3tbBbOt9vDyme6N=@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] LogicPD minimal board support for LV_SOM and Torpedo
From: Ashwin Bihari <abihari@gmail.com>
To: Tim Nordell <tim.nordell@logicpd.com>
Cc: Tony Lindgren <tony@atomide.com>, Stephan Linz <linz@li-pro.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 1:45 PM, Tim Nordell <tim.nordell@logicpd.com> wrote:
>  On 10/11/10 12:30, Tony Lindgren wrote:
>> Uhh, so whose patches are these originally?
>>
>> We have them now queued with Tim Nordell as the author. Please let me know
>> ASAP if you want me to change that.
>>
>> Regards,
>>
>> Tony
>
> The history for those patches, for me, originated with Jacob Tanenbaum's
> patchset.  I was taking over for him as he was going back to school.  I
> did some misc. changes for further submission, but I was not the
> original author.  I don't know Stephan's involvement - however, in the
> source files he's attributed credit in the header, as well as one of my
> coworkers so presumably there was some involvement on both ends.  I
> recognize some of the code as coming from our kernel release, so likely
> it was a hybrid originally between Stephan, Peter, and Jacob.
>
> That's about the extent that I know.
>
> - Tim

Tony,

LogicPD engineers did the initial porting and then Stephan Linz
re-started the work on the, then recent, 2.6.32 Kernel using our BSP
as a starting point. He was kind enough to send those LogicPD and we
began putting it together against the latest Linux Kernel for
inclusion and that was done by Jacob over the summer and finished off
by Tim.

Stephan Linz is credited in the patch and Peter Barada (another
LogicPD employee) is listed as the maintainer though his part (along
with me) in getting these specific patches out have been more behind
the scenes. So having the names listed as they are now is OK.

In the upcoming months we will be pushing out additional support for
the LogicPD's boards and it will most likely come up a variety of
LogicPD engineers depending on our workload..

Thanks
-- Ashwin
