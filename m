Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab2AKPP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 10:15:58 -0500
Received: from mga05.intel.com ([192.55.52.89]:5103 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757192Ab2AKPP4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 10:15:56 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxecGt54RG3EX+LTQQx6ZXzYLOMRdgRmXTRDaD54JAVGg@mail.gmail.com>
References: <alpine.LRH.2.00.1201091252220.18816@tundra.namei.org>
	<CA+55aFwD2-bhd32L1SsjPQrpwOBhBdxTUaOj=oXN24vPwc+Wsg@mail.gmail.com>
	<alpine.LRH.2.00.1201111834570.2966@tundra.namei.org>
	<CA+55aFxecGt54RG3EX+LTQQx6ZXzYLOMRdgRmXTRDaD54JAVGg@mail.gmail.com>
Date: Wed, 11 Jan 2012 17:15:53 +0200
Message-ID: <CALLzPKaSmpKot=bgm7qQ8a7J4-sxXLsMPrHz6Pe0SyzWpZp-yQ@mail.gmail.com>
Subject: Re: [GIT] Security subsystem updates for 3.3
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 4:51 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Jan 10, 2012 at 11:35 PM, James Morris <jmorris@namei.org> wrote:
>>> And "DIGSIG" is really a horrible config name. Did somebody run out of
>>> letters suddenly? Is there some global letter shortage that I haven't
>>> been told of and that we should do something about?
>>
>> Any objections to DIGITAL_SIGNATURE_API ?
>
> Sounds much better. Slightly more typing, but CONFIG_DIGSIG really
> didn't tell me anything and sounded like some odd new device to me.
>
>                          Linus

Would just DIGITAL_SIGNATURE be enough?

- Dmitry
