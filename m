Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab1BYCjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 21:39:55 -0500
Received: from smtp-out.google.com ([74.125.121.67]:56772 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab1BYCjx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 21:39:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rd3PSxKZy481eZVLLD3mTQalMiporBXqyprW3mz9cN5dfh4CKf4XaULpZYrp87VD30
         LHN5OxI6bvfxzt3tnR+A==
MIME-Version: 1.0
In-Reply-To: <1298601346.17118.29.camel@m0nster>
References: <1298585954-22422-1-git-send-email-kheitke@codeaurora.org>
	<1298585954-22422-3-git-send-email-kheitke@codeaurora.org>
	<1298600621.17118.27.camel@m0nster>
	<8yad3mgdeut.fsf@huya.qualcomm.com>
	<1298601346.17118.29.camel@m0nster>
Date: Thu, 24 Feb 2011 18:39:48 -0800
X-Google-Sender-Auth: E2mzbswOjDvaQ6FnNYiWcrB-Hy8
Message-ID: <AANLkTikD1Ued=rit1QbMWwe3NGFz2iQ-KO7B=-N6Ok-2@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] msm: add single-wire serial bus interface (SSBI) driver
From: Dima Zavin <dima@android.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: David Brown <davidb@codeaurora.org>,
        Kenneth Heitke <kheitke@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        tsoni@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        swetland@google.com, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On that note, should we have a "drivers/arm/msm" instead of just
"drivers/msm"? Other non-msm arm sub-arches probably have the same
problem and polluting drivers/ top-level for every arm-subarch maybe
undesirable.

--Dima


On Thu, Feb 24, 2011 at 6:35 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> On Thu, 2011-02-24 at 18:31 -0800, David Brown wrote:
>> On Thu, Feb 24 2011, Daniel Walker wrote:
>>
>> > You have some submission problems. one is that the subject should be
>> > "drivers: msm: ..." , this patch also shouldn't go to David.
>>
>> Subject needs to be fixed.  Patch to add drivers/msm to the maintainers
>> file has been Acked, so this should be sent to the MSM maintainers.
>
> It was only acked by Nico, he's just the one who suggested it. I think
> Greg needs to be involved at some level ..
>
> Daniel
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
