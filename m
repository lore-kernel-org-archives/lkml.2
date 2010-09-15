Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab0IONzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 09:55:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38003 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab0IONzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 09:55:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UQGI2uSMn5+1gGl7veqHIfNF2pL3LYVrkI3U4Obsnb8MLBo6UdbVwDoRgjeSTpDJcp
         AryGNRaU6+ColkFGyRv4ZVgW1lG+thD9T1sV3RuWHrb5/+N/LALOIPL6xmHpc+wgs/s5
         9EA2PA5FHN2gd2MSoRo4WPran47+4BhR2QF9I=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1009151500060.2416@localhost6.localdomain6>
References: <tip-54ff7e595d763d894104d421b103a89f7becf47c@git.kernel.org>
	<alpine.LFD.2.00.1009151500060.2416@localhost6.localdomain6>
Date: Wed, 15 Sep 2010 09:54:59 -0400
Message-ID: <AANLkTineVitetJgKS2AsZUMvuuxDhcPF45dFWK8rtFfd@mail.gmail.com>
Subject: Re: [PATCH RFC] x86: hpet: Avoid the readback penalty
From: John Drescher <drescherjm@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Nix <nix@esperi.org.uk>,
        Artur Skawina <art.08.09@gmail.com>,
        Damien Wyart <damien.wyart@free.fr>,
        Venkatesh Pallipadi <venki@google.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 9:11 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 14 Sep 2010, tip-bot for Thomas Gleixner wrote:
>> x86: hpet: Work around hardware stupidity
>
> After my brain recovered from yesterdays exposure with the x86 timer
> horror, I came up with a different solution for this problem, which
> avoids the readback of the compare register completely. It works
> nicely on my affected ATI system, but needs some exposure to the other
> machines.
>
> Comments ?
>

I can test this on my i7 machine in tonight (around 12 hours from now).

John
