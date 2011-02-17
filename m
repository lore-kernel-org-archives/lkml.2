Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab1BQH7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 02:59:47 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38507 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab1BQH7o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 02:59:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=j4C1PzfD2k7KVbuw3JiQ+OOWVlm3EW/Ei48MBDmjBMPz2rJNcN0Y8iBWJS/PYEv0Xu
         CG4w94ipKm6/O1Y+5OZiGTCR0YnzUGEVWdk9r/XgRLGBru2M5R27ot+oQphmJpAD+7cI
         sLzKHUZ4VNvxN1A0id/86j+S7eHToyCkHLblg=
MIME-Version: 1.0
In-Reply-To: <loom.20110217T003826-785@post.gmane.org>
References: <9F0C2539CB50A743894F8FCEEB1D569206F4A5@mx1.guavus.com>
	<loom.20110217T003826-785@post.gmane.org>
Date: Thu, 17 Feb 2011 10:59:43 +0300
Message-ID: <AANLkTikEMOxtTe7afmYsvyQkJi7j70TRX3cPPR0X=uQj@mail.gmail.com>
Subject: Re: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ryan Underwood <ryan.underwood@flightsafety.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 3:17 AM, Ryan Underwood
<ryan.underwood@flightsafety.com> wrote:
> Preeti Khurana <Preeti.Khurana <at> guavus.com> writes:
>
>>
>> I am getting the similar issue as reported
>> in https://lkml.org/lkml/2011/2/10/187
>>
>> Can someone tell me if the same issue  because I am getting the
>> problem on Intel Xeon..
>>
>
> I am seeing exactly the same problem (on 2.6.35 as Preeti reported originally)
> on some Xeon servers but only with recently shipped BIOS revisions. The OS is
> CentOS 5.5.
>
...
> I have not tried the following patches yet which seem to both be for spurious
> NMI messages, not accompanied by system lockups:
>
> https://lkml.org/lkml/2011/2/16/106
> https://lkml.org/lkml/2011/2/1/286
>
> Both nmi_watchdog=0 and pcie_aspm=off options do not solve the problem.
>
> I am not subscribed so please Cc me.
>

Since nmi_watchdog=0 didn't help -- I believe it's a different issue unrelated
to 'perf' patches you mentioned, probably rcu-people help is needed here.
