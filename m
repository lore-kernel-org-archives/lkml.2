Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190Ab2HWSeC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:34:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43497 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab2HWSd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:33:59 -0400
Message-ID: <50367790.4080207@gmail.com>
Date: Thu, 23 Aug 2012 11:33:52 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: wbrana <wbrana@gmail.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, Martin Nybo Andersen <tweek@tweek.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Drop support for x86-32
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com> <201208231814.21168.tweek@tweek.dk> <CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com> <20120823180839.GR23464@ZenIV.linux.org.uk> <CAJ7jCmnX17MLoHe9=bL-A2ja_qyfMw2Pa4x9oOj7TCX6rjCDgQ@mail.gmail.com> <5036750A.301@gmail.com> <CAJ7jCmkbujxcUYjQgS9a3pdHtdLmTukJCzExb4TAxLcZG=UJmg@mail.gmail.com>
In-Reply-To: <CAJ7jCmkbujxcUYjQgS9a3pdHtdLmTukJCzExb4TAxLcZG=UJmg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 11:30 AM, wbrana wrote:
> On 8/23/12, David Daney <ddaney.cavm@gmail.com> wrote:
>> Exactly what part of your user-space code requires special handling to
>> accommodate the differences between the two 32-bit x86 ABIs?  Please be
>> specific.
> My code doesn't need special handling,
[...]

I suspected as much.  So from your point of view, this issue is of 
exactly zero importance.


David Daney

