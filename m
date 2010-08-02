Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab0HBOm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 10:42:57 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61649 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab0HBOm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 10:42:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=bG8Jtwi73RXZQ4DqQ37qF1QYStS6+wDXNzGswTU97wyfKnoHfpkEO3Zp5fU9VlMVYH
         Ytl679tdqnQnfrqTiVu/QfRB3TlU3DDgekmtH8Z//OuxpO+E268Yl5XU1d313EuwgJut
         1A466Mk20SxlP07Jvy+oKBCpFLlLZUebsSapQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTikjUtTwaP5-LnYX8v3hjcuVbtenoH-yFvcPGf-+@mail.gmail.com>
References: <AANLkTik7powjUaJ51bA_bgPVb03U-RVZay3NffHBYLzx@mail.gmail.com>
	<215375.1280753770@localhost>
	<AANLkTi=keL2rUzxdxgscTU9cQSNxOnAtGVuAwTq9Wfuq@mail.gmail.com>
	<AANLkTikjUtTwaP5-LnYX8v3hjcuVbtenoH-yFvcPGf-+@mail.gmail.com>
Date: Mon, 2 Aug 2010 16:42:47 +0200
Message-ID: <AANLkTina0PZmTaQLw228k5kQnE=GPyYJzcUbO3nkkHF3@mail.gmail.com>
Subject: Re: a Great Idea - include Kademlia networking protocol in kernel
From: Damjan Jovanovic <damjan.jov@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If all you want to do is share a Kademlia implementation among
applications, it should be in a user-space shared library. This
library could also be ported to other operating systems, unlike a
Linux-only kernel module that portable applications wouldn't want to
use anyway.

I think Kademlia only belongs in the kernel if something in the kernel
itself needs it. And even then it shouldn't be exported to user space.

Damjan Jovanovic

On Mon, Aug 2, 2010 at 4:29 PM, hp fk <fkhp101@gmail.com> wrote:
> ---------- Forwarded message ----------
> From: hp fk <fkhp101@gmail.com>
> Date: 2010/8/2
> Subject: Re: a Great Idea - include Kademlia networking protocol in kernel
> To: Valdis.Kletnieks@vt.edu
>
>
> popular file sharing p2p applications like emule and bittorrent,
> innovative application like Osiris each has its own Kademlia protocol
> implementation in userspace presently. the imaginable kernel support
> needed is to reduce many repeated (different or same) Kademlia
> protocol implementations running in userspace to a consolidated one at
> kernel level, so that the Kademlia protocol as a p2p network
> infrastructure is provided in kernel and any p2p application could
> just use the interface provided by kernel, thus a great p2p network is
> easily created, and  applications on that network infrastructure could
> grow rapidly.
>
> 2010/8/2  <Valdis.Kletnieks@vt.edu>:
>> 1) You failed to explain what kernel support, if any, would be needed for this
>> protocol.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
