Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab1KWQqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:46:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52613 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab1KWQqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:46:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAHR064gRQ7ZUTsMkqY_2AEdUqFUnd5+uuEBjEPzVL+eifvr6qA@mail.gmail.com>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
	<1321999366-23784-16-git-send-email-corentincj@iksaif.net>
	<20111122222909.GO24283@suse.de>
	<CAHR064gRQ7ZUTsMkqY_2AEdUqFUnd5+uuEBjEPzVL+eifvr6qA@mail.gmail.com>
Date: Wed, 23 Nov 2011 17:46:14 +0100
Message-ID: <CANq1E4QHmS1ve5fnyWLaH9GaW-T4vqAUB_+72B-s=D0EYjEZZg@mail.gmail.com>
Subject: Re: [PATCH 15/15] samsung-laptop: promote myself as maintainer of samsung-laptop
From: David Herrmann <dh.herrmann@googlemail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Greg KH <gregkh@suse.de>, platform-driver-x86@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corentin

On Wed, Nov 23, 2011 at 7:38 AM, Corentin Chary
<corentin.chary@gmail.com> wrote:
> On Tue, Nov 22, 2011 at 11:29 PM, Greg KH <gregkh@suse.de> wrote:
>> On Tue, Nov 22, 2011 at 11:02:46PM +0100, Corentin Chary wrote:
>>> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
>>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>>
>> YEAH!!!!!
>>
>> Note, I am willing to dig up my old "special Linux bios" machine for
>> testing if you want me to verify nothing gets broken after you respin
>> this patch series.
>
> Great, I'll ping you.
>

I have tested the whole patchset on my Samsung N210. It works for me.
I've commented on a few patches about some small stuff. But it didn't
break any existing stuff / introduce regressions.

Feel free to carry this on the patches:
Tested-by: David Herrmann <dh.herrmann@googlemail.com
I haven't had the time to review the code more deeply, though. I might
do that later.

Thanks for the patches
David
