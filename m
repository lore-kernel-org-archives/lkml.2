Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032026Ab2CORfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:35:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58814 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965336Ab2CORfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:35:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXcsxVtDcqejEx_n79TosE_WUt77RMomh6jhQzuoLuv-Q@mail.gmail.com>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
 <1331362837-10740-23-git-send-email-yinghai@kernel.org> <CAErSpo4=pL_y0q=1-4GMGenOmKmLFgtAbpYi3GNrErGVZqCcBg@mail.gmail.com>
 <CAE9FiQXcsxVtDcqejEx_n79TosE_WUt77RMomh6jhQzuoLuv-Q@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 15 Mar 2012 11:34:46 -0600
Message-ID: <CAErSpo5AwEwvo6MyyKVkBM13FM-nKJ8FAcUxiG+tVFtVkwmvFg@mail.gmail.com>
Subject: Re: [PATCH v2 22/37] PCI, acpiphp: remove hot-add support of pci host bridge
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 11:58 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Mar 12, 2012 at 8:14 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Sat, Mar 10, 2012 at 12:00 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> It causes confusing.
>>
>> "causes confusion."
>>
>>> We may only need acpi hp for pci host bridge.
>>>
>>> Split host bridge hot-add support to another file, and keep acpiphp simple.
>>
>> I think it's a good thing to remove host bridge hotplug from acpiphp;
>> thanks for doing that.
>>
>> However, I think you removed it here, but didn't add it elsewhere
>> until a different patch.  That means we can't bisect across this.  It
>> would be better to do the entire move in a single patch.
>
> do you mean merge patch 22 and 23 together?

Yes, I think so.  You should have a single "move," not separate
patches that "remove" then "add."
