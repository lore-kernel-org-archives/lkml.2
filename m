Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab0JECBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 22:01:04 -0400
Received: from tuxonice.net ([74.207.252.127]:57499 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522Ab0JECBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 22:01:02 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4CAA86DA.3080601@tuxonice.net>
Date: Tue, 05 Oct 2010 13:00:58 +1100
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Dave Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUG][PATCH] 2.6.36-rc showstopper (at least for me) in vmwgfx
References: <4CAA5BDA.7080705@tuxonice.net> <AANLkTikzSQuBOWR=Bf_3xuS+ioyvZ3LLXGuRnN-CHj7p@mail.gmail.com>
In-Reply-To: <AANLkTikzSQuBOWR=Bf_3xuS+ioyvZ3LLXGuRnN-CHj7p@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 05/10/10 12:51, Dave Airlie wrote:
> On Tue, Oct 5, 2010 at 8:57 AM, Nigel Cunningham<nigel@tuxonice.net>  wrote:
>> Running a kernel based on the Rafael's -next tree, under VMware, I get the following oops while booting:
>
> Should already be fixed in Linus tree by,
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f1a28ee238bddfa48c5233543926af65a4445bf6

Ah, great. Thanks!

Nigel
