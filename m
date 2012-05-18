Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968178Ab2ERWqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:46:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32786 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967348Ab2ERWp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:45:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120517233426.57DFC3E062C@localhost>
References: <1334696661-3569-1-git-send-email-seth.heasley@intel.com>
 <CACRpkdam72rzUNWabCOG3GoCXiYqwv=EYHniUmSeZpdqyOV-ng@mail.gmail.com> <20120517233426.57DFC3E062C@localhost>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 18 May 2012 16:45:38 -0600
X-Google-Sender-Auth: HXMtho3j-W9pZeJySPCgMAB8iz0
Message-ID: <CACxGe6t9O6pATvM54PTE9fuTw85TTmnLzKYy6q=Nhm44BffVnQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] gpio-sch: Add Intel Centerton DeviceID for GPIO
To: Linus Walleij <linus.walleij@linaro.org>,
        Seth Heasley <seth.heasley@intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <samuel.ortiz@solidboot.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 5:34 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Wed, 18 Apr 2012 13:42:26 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Tue, Apr 17, 2012 at 11:04 PM, Seth Heasley <seth.heasley@intel.com> wrote:
>>
>> > This patch adds the Intel Centerton processor DeviceID for GPIO. The DeviceID is defined in include/linux/pci_ids.h
>> >
>> > Signed-off-by: Seth Heasley <seth.heasley@intel.com>
>>
>> That's straight-forward :)
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> Applied, thanks.

Oops, this depends on the pci device id change in patch 1 which Samuel
is picking up.  I'm dropping it from my tree since it should get
merged with the other patches.

g.
