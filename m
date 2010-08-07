Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab0HGEt6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 00:49:58 -0400
Received: from mail.lang.hm ([64.81.33.126]:48781 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab0HGEtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 00:49:55 -0400
Date: Fri, 6 Aug 2010 21:49:51 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: KCONFIG savedefconfig
In-Reply-To: <20100807040916.GB30520@merkur.ravnborg.org>
Message-ID: <alpine.DEB.2.00.1008062146260.30564@asgard.lang.hm>
References: <alpine.DEB.2.00.1008062024320.30564@asgard.lang.hm> <20100807040916.GB30520@merkur.ravnborg.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Aug 2010, Sam Ravnborg wrote:

> On Fri, Aug 06, 2010 at 08:25:43PM -0700, david@lang.hm wrote:
>> when savedefconfig decides what to write out, what does it do for things
>> that are not at the default, but were set to not be default as part of
>> dependancy resolution?
>
> The short version:
> Any symbol that does not have default value are written to
> the defconfig file.
>
> Using the defconfig file as input or using the full config file
> as input shall result in the same configuration.
> If not you found a bug we need to fix.

Ok, so I take this to mean that if selecting one symbol forces selection 
of another, then both symbols will be written to the defconfig file, even 
though only the first would be needed to recreate the full file.

this is a wonderful step forward, I'm just trying to understand the 
nuances of it.

David Lang

> Arve found one bug I have to look into - pending feedback.
> And I have found one bug related to tristate choice values.
>
> So a bit work is needed to make it ready :-(
> But it works for most of the defconfig we have today.
