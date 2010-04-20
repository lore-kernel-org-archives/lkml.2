Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab0DTDCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 23:02:06 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:65009 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab0DTDCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 23:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d20T+4/Zq4td5F1jkFepxsg9OMsLdM/E72iIvXOuhw69SMk5jZ3WQQaNvdNUqYBvAV
         qlLpzO94CBDc+x9AO4FGqsgVvVL1DF42DK6HvOF70Fj9QTS+yUghYMkXfhTeBfp07jRw
         hXjVa22ute1Syaa/je32n4sMM4DXeoQs+FioY=
MIME-Version: 1.0
In-Reply-To: <k2w363172901004191854t72fa19fahdb93fa498b23fcf6@mail.gmail.com>
References: <k2s363172901004182032zea2277b4s40e55ae436d2353e@mail.gmail.com>
	 <k2w363172901004191854t72fa19fahdb93fa498b23fcf6@mail.gmail.com>
Date: Tue, 20 Apr 2010 08:32:02 +0530
Message-ID: <j2ocfeab66d1004192002z8fd0b6acx52da44ca3210dc5f@mail.gmail.com>
Subject: Re: IPv4 NAT UDP Traversal issue
From: ratheesh k <ratheesh.ksz@gmail.com>
To: =?GB2312?B?t8nR1Q==?= <win847@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/20 ·ÉÑÕ <win847@gmail.com>:
> Dear all,
>
>       I have a question about Linux NAT, our Product is ADSL
> Router(Linux Version is 2.6.22.15), and Now our customers requirment
> is below:
>
>       IPv4 Nat: UDP Traversal through NAT, must support STUN
> (RFC3489)  the four ways: Full Cone¡¢Restricted Cone¡¢Port Restricted
> Cone and Symmetric
>
>       As I known, netfilter IPv4 NAT is belonged to Symmetric type.
> and if want UDP Traversal through NAT, NAT Device can not be Port
> Restricted Cone and Symmetric type if the other is Symmetric type.
>
>       So my question is: Can iptable set the UDP NAT converted to
> Full Cone or Restricted Cone type?
>
>       we now set NAT use iptables below£º
>
> Chain POSTROUTING (policy ACCEPT)
> target     prot opt source               destination
> MASQUERADE  all  --  anywhere             anywhere
>
>       Thanks very much!
>
> BR,
> win847
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

There is a dedicated mailing list for netfilter .
                      netfilter-users
