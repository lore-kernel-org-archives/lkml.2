Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab0FNPb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:31:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58923 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0FNPbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:31:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=IKFKyJzZAWUY0l3h3qgDTx/+NGjEUo6w/atEiZYt638p1nMt70AtjLr+Iefanx6i4f
         AhrAkReyM3GFGyH1EZcDGsA6ARBwiizicA7zp9T8lpapaWUrqRIscDD1gNQr0pnwyDac
         s4REIvb4xX3oFY31nTyZItFzUcpx0ngp4AUTw=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: linux-kernel@vger.kernel.org
Subject: Re: Noticeable slow-down in 2.6.35-rc3
Date: Mon, 14 Jun 2010 11:31:51 -0400
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
References: <AANLkTimDUf0N6b5PBy2wTGeAWEIY-lUvQPHQ7D7Gyrq4@mail.gmail.com> <201006131813.04096.gene.heskett@gmail.com> <hv58sc$b1b$1@dough.gmane.org>
In-Reply-To: <hv58sc$b1b$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006141131.51405.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 June 2010, walt wrote:
>On 06/13/2010 03:13 PM, Gene Heskett wrote:
>> Unfortunately, this patch will not apply to my src tree for 2.6.35-rc3,
>> even after I fixed the unwanted line wrap in the first active line.
>>
>> I get:
>>
>> [root@coyote linux-2.6.35-rc3]# patch -p1<../2.6.35-rc3-test.patch
>> patching file net/core/skbuff.c
>> Hunk #1 FAILED at 532.
>> 1 out of 1 hunk FAILED -- saving rejects to file net/core/skbuff.c.rej
>>
>> Did my grabbing it with swiftfox damage it even further?
>> ------------------------------------------------------------------
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index 9f07e74..bcf2fa3 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -532,6 +532,7 @@ static void __copy_skb_header(struct sk_buff *new,
>> const struct sk_buff *old) new-&gt;ip_summed		= old-&gt;ip_summed;
>
>I don't know what caused the corruption, but it's a systematic error.
>Throughout the patch, the dereference symbol -> has been changed to
>-& so it's not surprising that the patch won't apply.  I've never seen
>that particular problem before.
>
Neither have I, but that looks to be fixable, so I will give it a shot later 
today.  Thank you very much.

>I don't think the line numbers (e.g.532) are responsible.

Neither did I.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
This fortune was brought to you by the people at Hewlett-Packard.
