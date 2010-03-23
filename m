Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab0CWT1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 15:27:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41502 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab0CWT1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 15:27:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=BPBu3xfuwcYwqPOxpjDMeBpFDIoWLNuhxOPotx8rly6fjq1l5qVJTs92BOKVY1xcuN
         LlXRmbgzFiv37fywKUYsIL7Mad5W65jlwXO6+Vo3sJY6NZsY12trVpqblco2yd6/E1fJ
         W4OL2XxoaNykTwkHK7pToATYINbtKP/HFxnX4=
MIME-Version: 1.0
In-Reply-To: <20100319000438.GV5454@kroah.com>
References: <20100313001618.GA9811@kroah.com> <20100313001511.285517122@kvm.kroah.org> 
	<43e72e891003151804s617659f8o6dcbf0b5ab63cb5d@mail.gmail.com> 
	<20100319000438.GV5454@kroah.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 23 Mar 2010 12:26:49 -0700
X-Google-Sender-Auth: 33ea0f0f80f654c5
Message-ID: <43e72e891003231226q3be972dfl5bb8a022bdb5aaff@mail.gmail.com>
Subject: Re: [Stable-review] [stable] [patch 070/123] ath9k: re-enable ps by 
	default for new single chip families
To: Greg KH <greg@kroah.com>,
       Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: torvalds@linux-foundation.org, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>, stable@kernel.org,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       akpm@linux-foundation.org, Peter Stuge <peter@stuge.se>,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 5:04 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Mar 15, 2010 at 06:04:15PM -0700, Luis R. Rodriguez wrote:
>> On Fri, Mar 12, 2010 at 5:12 PM, Greg KH <gregkh@suse.de> wrote:
>> > 2.6.33-stable review patch.  If anyone has any objections, please let me know.
>>
>> This was intended for 2.6.32 as well. Thanks
>
> Great, but it didn't apply there, so I didn't try to force it :)
>
> Care to provide a backport?

Senthil, if you get a chance, can you send this backport? Sorry I
haven't had a chance yet.

  Luis
