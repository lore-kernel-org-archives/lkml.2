Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab0KESDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 14:03:16 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:38254 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab0KESDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:03:13 -0400
Message-ID: <4CD44587.2050001@collabora.co.uk>
Date: Fri, 05 Nov 2010 17:57:27 +0000
From: Ian Molton <ian.molton@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100917 Icedove/3.0.8
MIME-Version: 1.0
To: Alon Levy <alevy@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>,
        QEMU Developers <qemu-devel@nongnu.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.osdl.org, Avi Kivity <avi@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Qemu-devel] Re: [PATCH] Implement a virtio GPU transport
References: <1097264455.965471288612409433.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <4CCEC090.3050009@codemonkey.ws> <4CD1A406.3090909@collabora.co.uk> <20101104091358.GA28832@playa.tlv.redhat.com>
In-Reply-To: <20101104091358.GA28832@playa.tlv.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/10 09:13, Alon Levy wrote:
> On Wed, Nov 03, 2010 at 06:03:50PM +0000, Ian Molton wrote:
>> On 01/11/10 13:28, Anthony Liguori wrote:
>>> On 11/01/2010 06:53 AM, Alon Levy wrote:
>>
>>>> While we (speaking as part of the SPICE developers) want to have the same
>>>> support in our virtual GPU for 3d as we have for 2d, we just don't at
>>>> this point of time.
>>
>> Would it be helpful to you to have /something/ that works in the
>> interim? I'm happy to work with you guys so that we dont need to
>> reinvent the wheel ;-)
>
> In case it wasn't clear, I think putting virtio-gl is a good idea, exactly because it works right now.

Thanks :)

-Ian
