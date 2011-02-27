Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab1B0KHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 05:07:45 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54265 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab1B0KHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 05:07:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=a2X+/LRrg/hRskzPlq5dJz/dVCJiTHBbxGh3kj5ijLHR0amwVz1sUHY5ZZaobTxX6T
         AAnKpMPywtg9TDLBRNmKBcGoUduejPXHP5wtDJGNvcvkhuUE1SHyZnrHE24o5Wt7lJk1
         4R5tCXCWdR+W0zk8Vqt71MWHLp0O8lVsPriww=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1102262132320.12215@chino.kir.corp.google.com>
References: <20110225105205.5a1309bb.randy.dunlap@oracle.com>
	<1298747426-8236-1-git-send-email-mk@lab.zgora.pl>
	<alpine.DEB.2.00.1102262132320.12215@chino.kir.corp.google.com>
Date: Sun, 27 Feb 2011 12:07:41 +0200
X-Google-Sender-Auth: lwn7E1pQWSCW9160sDAlGwusMb8
Message-ID: <AANLkTimAC8VmpQ1ZAAAy1Wu5ZHffcDqp96MyzRoywjTc@mail.gmail.com>
Subject: Re: [PATCH] slub: fix ksize() build error
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Mariusz Kozlowski <mk@lab.zgora.pl>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-next@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[ Please CC me for slab allocator patches in the future. ]

On Sun, Feb 27, 2011 at 7:32 AM, David Rientjes <rientjes@google.com> wrote:
> On Sat, 26 Feb 2011, Mariusz Kozlowski wrote:
>
>> mm/slub.c: In function 'ksize':
>> mm/slub.c:2728: error: implicit declaration of function 'slab_ksize'
>>
>> slab_ksize() needs to go out of CONFIG_SLUB_DEBUG section.
>>
>> Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
>
> Acked-by: David Rientjes <rientjes@google.com>

Applied, thanks!

                      Pekka
