Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab1KOSjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 13:39:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab1KOSjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 13:39:10 -0500
Message-ID: <4EC2B1F7.6090108@suse.cz>
Date: Tue, 15 Nov 2011 19:39:51 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: How to remove 2000+ lines from 400+ defconfig files?
References: <1321362602.20271.192.camel@x61.thuisdomein>  <alpine.LNX.2.00.1111151412360.15187@pobox.suse.cz> <1321371462.20271.201.camel@x61.thuisdomein>
In-Reply-To: <1321371462.20271.201.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 15.11.2011 16:37, Paul Bolle napsal(a):
> On Tue, 2011-11-15 at 14:14 +0100, Jiri Kosina wrote:
>> I am fine taking those through trivial.git and handling the fallout.
>
> Great.
>
>> The only ones I'd have objections to taking immediately are those which are
>> actually still referenced somewhere in the code.
>> For those, either taking them through appropriate maintainers, or having
>> their Acked-by would be required.
>
> I don't mind. That shouldn't be a lot of extra work for me.
>
> But, I do have a naive question: are defconfigs meant to be drop in
> replacements for .config files or is one supposed to first feed them to
> the config tools to generate an up to date .config?

defconfig files are used as input of the conf program.

  Since, if one is
> supposed to feed them to the config tools first it doesn't matter
> whether the (outdated) macros are still used somewhere in the code,
> doesn't it? The config tools will simply drop all macros they can't
> match with Kconfig symbols. (Or don't they? Michal?)

Yes, they will not appear in the .config.

Michal
