Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0FDS0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 14:26:38 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58302 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab0FDS0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 14:26:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=HIhx5cMsPUltmsCtManoKmaW1csJap6ciQf3DjX/t+TNyfPTtVTzg0bjILkLKI0xuG
         6OlsuQq+63NFqb1MGKjRrWhEK6hwK3+1ZV6RVWppYeBv9vubm5F05hXPBMPZXJMGoxIe
         /tTp4VgUMpLP+by/6NWz4yDd7HYyDU4q3JbK8=
MIME-Version: 1.0
In-Reply-To: <20100604180225.GA2439@elliptictech.com>
References: <Pine.LNX.4.64.1006041547530.2447@boston.corp.fedex.com>
	<20100604180225.GA2439@elliptictech.com>
Date: Sat, 5 Jun 2010 02:26:36 +0800
Message-ID: <AANLkTikOvkqJFgI-TnKmzWALlOF29Dga719yhiGU0w7K@mail.gmail.com>
Subject: Re: Commit 9b8c4a0b215e603497daebe8ecbc9b1f0f035808 broken X11 
	pointer
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>,
       Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 5, 2010 at 2:02 AM, Nick Bowler <nbowler@elliptictech.com> wrote:
> On 15:53 Fri 04 Jun     , Jeff Chua wrote:
>> The following commit broke X11 mouse pointer. Symptom is "mouse pointer"
>> on X11 cannot change "shape" when positioned to the frames of xterm
>> window.
>>
>> Reverting it makes it work again.
>>
>> commit 9b8c4a0b215e603497daebe8ecbc9b1f0f035808
>
> Should be fixed by the patch attached to this bug:
>
>  https://bugs.freedesktop.org/show_bug.cgi?id=28335

Nick,

Thanks again for the pointer! And yes, the patch fixes the problem.
However, it hasn't make its way to Linus's tree yet.

Thanks,
Jeff.
