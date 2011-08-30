Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1H3Eg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 00:36:26 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56395 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1H3EgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 00:36:24 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1108300028470.20358@xanadu.home>
References: <1313800642-32418-1-git-send-email-lacombar@gmail.com>
	<CACqU3MVrSV-Qp7mC4iN_viMHz=2-cGPaqNY04eokYkVoE_pSuw@mail.gmail.com>
	<alpine.LFD.2.00.1108300028470.20358@xanadu.home>
Date: Tue, 30 Aug 2011 00:36:24 -0400
Message-ID: <CACqU3MUaq7ZgM+7JpE-A_6FuH2zr+nA4+7u8rzVedLJfcyEcwg@mail.gmail.com>
Subject: Re: [RFC] Kbuild: allow code re-use across different directories
From: Arnaud Lacombe <lacombar@gmail.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 30, 2011 at 12:32 AM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Mon, 29 Aug 2011, Arnaud Lacombe wrote:
>
>> On Fri, Aug 19, 2011 at 8:37 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> > With the attached patch, we would do:
>> >
>> > arch/foo/boot/Makefile:
>> > LDFLAGS_fancy.o := -DPANTS=30
>> > obj-y += fancy.o
>> > vpath-y += $(srctree)/arch/foo/lib
>> >
>> > and let GNU make do the job.
>> >
>> Nicolas, I guess you were the one who was interested for a generic way
>> to do such code re-use, did you had any chance to test the quoted
>> patch ?
>
> I actually missed the original post (I wasn't in CC) so I didn't test it.
> Will try to do so ASAP.
>
Sorry for the miss, I thought linux-arm-kernel@ would catch enough people :)

 - Arnaud
