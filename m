Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab0GKHN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 03:13:28 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41318 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab0GKHN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 03:13:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FXr3oHTZHGtXFRNgncPUYUym51fXuUYvG6e/rjagJLUPN/UCjMGBYogTcs1WTwX+O5
         qB4PHYJ7xZp2uBkv3DjeHgxlq56U/sV0rVOxx66wXBWdZQ2ohB3EohJnYktHPDaydpcD
         +TX52vEGClfCCJjWs6uXgPqkR8itNWxxZcV4I=
MIME-Version: 1.0
In-Reply-To: <AANLkTikqNLp5HN0Puu00_bbJEQCUNCCtSsOFxuxfX5g0@mail.gmail.com>
References: <1278695580.2696.55.camel@edumazet-laptop>
	<AANLkTil39xHOhcdAo4h_jWtx_UuYdFHGdQVAdwPMd7QJ@mail.gmail.com>
	<1278742649.2538.17.camel@edumazet-laptop>
	<20100710.123011.260095467.davem@davemloft.net>
	<AANLkTilQbM8F27a5SLZLMzndLYfz-eRhzyxP18KCFz2K@mail.gmail.com>
	<AANLkTikqNLp5HN0Puu00_bbJEQCUNCCtSsOFxuxfX5g0@mail.gmail.com>
Date: Sun, 11 Jul 2010 04:13:24 -0300
Message-ID: <AANLkTin5mn2MsxoduNBZ0Q8vTqBqaxVs9A9JnbfdikaC@mail.gmail.com>
Subject: Re: [PATCH] tproxy: nf_tproxy_assign_sock() can handle tw sockets
From: Felipe W Damasio <felipewd@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, kaber@trash.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/11 Felipe W Damasio <felipewd@gmail.com>:
>   The production machine has 8GB of RAM:

  I'm sorry, this is not right. The production machine has 16GB of RAM.

  Don't know if that matters regarding those proc parameters, though.

  Cheers,

Felipe Damasio
