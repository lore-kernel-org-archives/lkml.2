Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab1BYHKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 02:10:20 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:49278 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab1BYHKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 02:10:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=GdAmeq531g4AiL+VUn/jPlJx96z5vg41nOtbpXYUD1bBHy/Fj5oW8lc8HDb/gj3Fg4
         4Wwktg1UxeatjcN+RxxEdKmfDOnYjkSfBAUP7ndCZBgFNYW/b6UzL5uPiNR8jfMK2qgr
         wA2Eouq2k4hH1vxPf13SdGiJ3Yq68nWMV1uK0=
Cc: trivial@kernel.org, johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <C0CEB11E-CD60-4A10-BFC8-7CB555D1413C@gmail.com>
From: Justin Mattock <justinmattock@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
In-Reply-To: <AANLkTi=FuD0FCTv6f0sPKkg14O9R_giKi9uvA0Xsgy1q@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 18/21]include:net:mac80211.h remove one to many l's in the word.
Date: Thu, 24 Feb 2011 23:10:15 -0800
References: <1298614522-4153-1-git-send-email-justinmattock@gmail.com> <AANLkTi=FuD0FCTv6f0sPKkg14O9R_giKi9uvA0Xsgy1q@mail.gmail.com>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 24, 2011, at 10:20 PM, Julian Calaby wrote:

> On Fri, Feb 25, 2011 at 17:15, Justin P. Mattock
> <justinmattock@gmail.com> wrote:
>> The patch below removes an extra "l" in the word.
>
> Random thought:
>
> Not that I'm complaining about your work here, and not that commits
> are a finite resource, but would it be possible for you to collect
> your spelling changes into slightly bigger commits before sending them
> off?
>
> E.g. instead of sending off 21 patches to remove 21 erroneous l's, why
> not do a full spelling check on these 21 files, then send off 21
> patches to fix *all* the spelling mistakes in each file? You could
> even group them up by directory if you liked.
>
> Thanks,
>
> --  
>
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
> .Plan: http://sites.google.com/site/juliancalaby/


yeah.. I agree, its just people have said that I should individually
send each patch to each maintainer subsystem etc...
(rather would just send one with everything on it, but then might make  
things more confusing)

Justin P. Mattock
