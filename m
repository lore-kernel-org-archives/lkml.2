Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab1BABMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 20:12:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44753 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab1BABMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 20:12:07 -0500
Message-ID: <4D475DB5.1020300@zytor.com>
Date: Mon, 31 Jan 2011 17:11:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
References: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com> <20110130113356.GA27967@liondog.tnic> <4D461FB9.5050807@goop.org> <20110131070241.GA22071@liondog.tnic> <4D46FC9F.6090309@goop.org> <20110131234131.GA16095@liondog.tnic> <4D475099.1080004@goop.org>
In-Reply-To: <4D475099.1080004@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: Xen may not have devices, but it is already using multiboot to 
load multiple modules.  It could load the microcode blob that way.

That would enable an earlier loading of microcode, which is a very good 
thing.

	-hpa
