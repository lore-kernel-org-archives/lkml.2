Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760889Ab0HFCEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 22:04:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35944 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab0HFCEk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 22:04:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dNbRlZ/RqyLi4CnHoYIuslWfkuFVS9FazUF6Y5sCWjEQYl4+FO9e893PaH39mbzjoJ
         tYSWMn1j9g97xwHE5fmGAkMF21zHxo+Up+ABnUNELk0TWgIGHSieYxazF1oqr0QxFwGH
         m06fAWfZf161OEPElQ7Xx/vE4RDklzgMY/Qlo=
MIME-Version: 1.0
In-Reply-To: <AANLkTimxv1y3QJ7s+ghi1FFCcwnUVWT1n6dvT-NNN=Oo@mail.gmail.com>
References: <20100803.203814.59697285.davem@davemloft.net>
	<AANLkTimxv1y3QJ7s+ghi1FFCcwnUVWT1n6dvT-NNN=Oo@mail.gmail.com>
Date: Thu, 5 Aug 2010 19:04:39 -0700
X-Google-Sender-Auth: 7x0PbOxp-Y_w58SSvYe1xoPjYZk
Message-ID: <AANLkTinU4+tcm2O_BVBFkHSdnx7JEPtM4sw_s--qdUKC@mail.gmail.com>
Subject: Re: [GIT] Networking
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 12:06 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Aug 3, 2010 at 8:38 PM, David Miller <davem@davemloft.net> wrote:
>>
>> Another release, another merge window, another set of networking
>> changes to merge :-)
>
> Ok, merged. But you should double-check my merge resolution fixes,

  CC      drivers/net/ixgbe/ixgbe_main.o
drivers/net/ixgbe/ixgbe_main.c: In function ‘ixgbe_select_queue’:
drivers/net/ixgbe/ixgbe_main.c:6159: error: ‘struct ixgbe_fcoe’ has no
member named ‘up’
drivers/net/ixgbe/ixgbe_main.c: In function ‘ixgbe_xmit_frame’:
drivers/net/ixgbe/ixgbe_main.c:6221: error: ‘struct ixgbe_fcoe’ has no
member named ‘up’
make[1]: *** [drivers/net/ixgbe/ixgbe_main.o] Error 1
make: *** [drivers/net/ixgbe/] Error 2

YH
