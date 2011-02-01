Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab1BAWwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:52:42 -0500
Received: from claw.goop.org ([74.207.240.146]:39094 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab1BAWwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:52:41 -0500
Message-ID: <4D488EB1.9020803@goop.org>
Date: Tue, 01 Feb 2011 14:52:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
References: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com> <20110130113356.GA27967@liondog.tnic> <4D461FB9.5050807@goop.org> <20110131070241.GA22071@liondog.tnic> <4D46FC9F.6090309@goop.org> <20110131234131.GA16095@liondog.tnic> <4D475099.1080004@goop.org> <4D475DB5.1020300@zytor.com>
In-Reply-To: <4D475DB5.1020300@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 05:11 PM, H. Peter Anvin wrote:
> Note: Xen may not have devices, but it is already using multiboot to
> load multiple modules.  It could load the microcode blob that way.
>
> That would enable an earlier loading of microcode, which is a very
> good thing.

Yes, that is a thought, but it would require some distro support to make
sure the firmware is copied into /boot, and grub updated appropriately.

The principle advantage of updating the microcode driver is that it Just
Works regardless of whether the system is booting native or Xen.

    J
