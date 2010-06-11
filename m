Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0FKQ3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 12:29:21 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:54182 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab0FKQ3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 12:29:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=m1AI00izKoO4KtW0dlW4I5pirtIrihzCAEiC+OTbsVSENkBYAIbfgbpGt4O8BEJXz4
         NxbOcq5Ktq+C5geB0QDTwbCCrsyTuI1TEZ2GlElQAxcLlHadRMOc7gfy7YaS30QY9YTs
         OFV7gfNBy4ctp5ff1jJGt+ZXi7mqxeVvv5864=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006091821060.1402@localhost.localdomain>
References: <AANLkTil6GGSoc8TpzRacr1LZBZS3ee3H1ejYDSqfdul4@mail.gmail.com>
	<20100529202253.0bd18bbd.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1006091821060.1402@localhost.localdomain>
Date: Fri, 11 Jun 2010 10:29:13 -0600
Message-ID: <AANLkTilrLYu6H3GtAcP-cHpFvrm3v22uCw2EUeW_ZK0k@mail.gmail.com>
Subject: Re: Linux 2.6.34 causes system lockup on Compaq Presario 2200 Laptop
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len,

I am having trouble getting a trace of this because its down hard to
reproduce.  The reason is the lockup happens before I log into the
laptop.  i.e. I boot 2.6.34 and if I let the laptop just sit there is
happens.  If I log in and start doing work on it, it does not seem to
happen.  It's related to using the laptop on battery mode with the
charger removed.  I have a 2U appliance setup I am working on today
and this frees up the laptop to try to reproduce this.  The flaky
battery power misreporting was in fact accurate.  The battery in that
laptop is 6 years old and does have low power.  I am certain the
lockup if related though.  I will try to reproduce today and setup the
trace to run after boot.  I have had it sitting there for an  hour and
it has not reoccurred.  Let me try through today and if I cannot
reproduce, close the bug.

Jeff

On Wed, Jun 9, 2010 at 4:21 PM, Len Brown <lenb@kernel.org> wrote:
> Jeff,
> Please attach the output of acpidump here:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=16136
>
> thanks,
> Len Brown, Intel Open Source Technology Center
>
