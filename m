Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab0KJRsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:48:07 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37622 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab0KJRsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:48:00 -0500
Message-ID: <4CDADACC.4070405@codemonkey.ws>
Date: Wed, 10 Nov 2010 11:47:56 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Ian Molton <ian.molton@collabora.co.uk>
CC: QEMU Developers <qemu-devel@nongnu.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        virtualization@lists.osdl.org, Alon Levy <alevy@redhat.com>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [Qemu-devel] Re: [PATCH] Implement a virtio GPU transport
References: <1097264455.965471288612409433.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>	<4CCEC090.3050009@codemonkey.ws>	<4CD1A406.3090909@collabora.co.uk> <4CD1A73B.2010406@codemonkey.ws> <4CD44759.5020500@collabora.co.uk> <4CDAD4D4.3070009@collabora.co.uk>
In-Reply-To: <4CDAD4D4.3070009@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2010 11:22 AM, Ian Molton wrote:
> Ping ?

I think the best way forward is to post patches.

To summarize what I was trying to express in the thread, I think this is 
not the right long term architecture but am not opposed to it as a short 
term solution.  I think having a new virtio device is a bad design 
choice but am not totally opposed to it.

My advice is that using virtio-serial + an external tool is probably the 
least amount of work to get something working and usable with QEMU.  If 
you want to go for the path of integration, you're going to have to fix 
all of the coding style issues and make the code fit into QEMU.  
Dropping a bunch of junk into target-i386/ is not making the code fit 
into QEMU.

If you post just what you have now in patch form, I can try to provide 
more concrete advice ignoring the coding style problems.

Regards,

Anthony Liguori

