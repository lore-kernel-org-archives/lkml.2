Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1HUXdB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 19:33:01 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38620 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab1HUXdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 19:33:00 -0400
MIME-Version: 1.0
In-Reply-To: <20110821231354.GL25996@one.firstfloor.org>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
	<CACqU3MWgZG_jGs+26X05nXUpbihASU7JXaBct=ZBnR7SEWLc+w@mail.gmail.com>
	<20110821231354.GL25996@one.firstfloor.org>
Date: Sun, 21 Aug 2011 19:32:59 -0400
Message-ID: <CACqU3MUAuMMC0c1Aesb3-oSzRXw4ddRYtjKDYovXewbCFL6dFg@mail.gmail.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
From: Arnaud Lacombe <lacombar@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Aug 21, 2011 at 7:13 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Sun, Aug 21, 2011 at 06:28:28PM -0400, Arnaud Lacombe wrote:
>> Hi,
>>
>> On Fri, Aug 19, 2011 at 7:15 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> > From: Andi Kleen <ak@linux.intel.com>
>> >
>> > Reposting due to popular demand. Several other people are running
>> > into the same problem with all kinds of software.
>> >
>> > Only change is rebase against current master.
>> >
>> FWIW, couldn't this be made a boot option ?
>
> init=/script/that/runs/uname26/sbin/init
>
It does not work if / on a ROM, unless you start using trampoline
partition, but this is starting to become really convoluted...

 - Arnaud
