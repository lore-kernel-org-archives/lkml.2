Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab2AKOvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 09:51:35 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33171 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938Ab2AKOvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 09:51:32 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1201111834570.2966@tundra.namei.org>
References: <alpine.LRH.2.00.1201091252220.18816@tundra.namei.org>
 <CA+55aFwD2-bhd32L1SsjPQrpwOBhBdxTUaOj=oXN24vPwc+Wsg@mail.gmail.com> <alpine.LRH.2.00.1201111834570.2966@tundra.namei.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Jan 2012 06:51:10 -0800
X-Google-Sender-Auth: RycZEGV9OduIb3ukTXxSbjbhqas
Message-ID: <CA+55aFxecGt54RG3EX+LTQQx6ZXzYLOMRdgRmXTRDaD54JAVGg@mail.gmail.com>
Subject: Re: [GIT] Security subsystem updates for 3.3
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 11:35 PM, James Morris <jmorris@namei.org> wrote:
>> And "DIGSIG" is really a horrible config name. Did somebody run out of
>> letters suddenly? Is there some global letter shortage that I haven't
>> been told of and that we should do something about?
>
> Any objections to DIGITAL_SIGNATURE_API ?

Sounds much better. Slightly more typing, but CONFIG_DIGSIG really
didn't tell me anything and sounded like some odd new device to me.

                          Linus
