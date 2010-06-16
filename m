Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589Ab0FPLar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 07:30:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58468 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab0FPLao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 07:30:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=mxYan7MYD1/OE5cLI2O45REtrVNruFKuYhR2s/IRAqY5SpbTb+2farXMXt4slslDqT
         +wvxjiIZq69ufJ6EUOHaBAbxB2Nj3QpP3/kdZadCe0Kx8Ya212LAPdZl74p714Two2kl
         PnJ74NvLRoQUX1oMLiTFgxwz8wemZXyz9W3g4=
MIME-Version: 1.0
In-Reply-To: <20100616110914.GF9298@parisc-linux.org>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com> 
	<AANLkTikwKHITQJDaSf9BnHQ9FLiQ-KYlCWNiH438otsV@mail.gmail.com> 
	<20100616110914.GF9298@parisc-linux.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 16 Jun 2010 21:30:23 +1000
Message-ID: <AANLkTil-d7LqofvvB9_QGd7Quy4kPucWGpJ5LHl94LoP@mail.gmail.com>
Subject: Re: [PATCH 0/5] Fix set but unused variable warnings
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 21:09, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, Jun 16, 2010 at 03:52:58PM +1000, Julian Calaby wrote:
>> Given that patches 3, 4 and 5 seem to be a cases of missing error
>> handling, (3 and 4 in particular seem to be breaking things rather
>> than fixing them) in my humble opinion, I think this set needs some
>> work and discussion.
>>
>> Justin, maybe you'd be better off posting the actual error messages
>> (split up by subsystem) and letting the lists discuss them, rather
>> than posting patches which are obviously wrong. (like the ones I've
>> pointed out)
>
> My first impression of patch 5 was "that can't be right", but upon review,
> I concluded that was the best solution.  If we return the PTR_ERR, this
> is going to confuse every user of scsi_host_alloc who are currently only
> checking for NULL.

I did a double take at patch 4 when skimming over them, then took a
proper look at the lot of them. Whilst I agree that 5 isn't doing
anything particularly bad, it does seem wrong, especially in the
context of 3 and 4.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
