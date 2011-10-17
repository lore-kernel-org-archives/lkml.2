Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1JQHRC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 03:17:02 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39155 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1JQHRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 03:17:00 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110141252480.24783@chino.kir.corp.google.com>
References: <4E9869B4.6080702@intra2net.com>
	<alpine.DEB.2.00.1110141214270.6411@router.home>
	<4E9870A8.2010905@intra2net.com>
	<alpine.DEB.2.00.1110141252480.24783@chino.kir.corp.google.com>
Date: Mon, 17 Oct 2011 10:16:59 +0300
X-Google-Sender-Auth: yeE6qlyStv-HP0UigbqfFD1GpnU
Message-ID: <CAOJsxLGS519114eonOWbDTwO+CL_e=buiW7XdbtxfCUpYz=Y6A@mail.gmail.com>
Subject: Re: [slabinfo PATCH] Fix off-by-one after readlink() call
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 10:53 PM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 14 Oct 2011, Thomas Jarosch wrote:
>
>> The problem is the line after the readlink() call:
>>
>> buffer[count] = '\0';
>>
>> The common technique is to reduce the buffer size by one.
>> Another fix would be to check
>>
>> "
>> if (count < 0 || count == sizeof(buffer))
>>     fatal();
>> "
>>
>> Reducing the buffer size by one is easier IMHO.
>>
>
> I think this should be used for changelog.
>
> Acked-by: David Rientjes <rientjes@google.com>

Thomas, please resend with proper changelog and with David's and
Christoph's ACKs included.
