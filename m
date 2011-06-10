Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab1FJHNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 03:13:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40113 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab1FJHNC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 03:13:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Q+zkcXbwWOJJ0qySLbUS7B6ricghSWaVJj/Y16sEE8z48x+DfvRQYcnbvjEWy80wuH
         yA/w2wxuJAI1Uc3H3Y+w==
MIME-Version: 1.0
In-Reply-To: <20110610040012.GA14233@auslistsprd01.us.dell.com>
References: <1307389135-8150-1-git-send-email-mjg@redhat.com>
 <1307389135-8150-2-git-send-email-mjg@redhat.com> <BANLkTinHYQ14A7vzTxA1c2frxUVE6HWNQg@mail.gmail.com>
 <BANLkTimESgP1FMzP8cbKcECLSbEY9Mj3bQ@mail.gmail.com> <20110606214735.GA4026@srcf.ucam.org>
 <20110610040012.GA14233@auslistsprd01.us.dell.com>
From: Mike Waychison <mikew@google.com>
Date: Fri, 10 Jun 2011 00:12:39 -0700
Message-ID: <BANLkTin2f2Dn9onaazgxtkC2kWLrj6cOnw@mail.gmail.com>
Subject: Re: [PATCH 2/3] pstore: Add extra context for writes and erases
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 9:00 PM, Matt Domsch <Matt_Domsch@dell.com> wrote:
> On Mon, Jun 06, 2011 at 10:47:35PM +0100, Matthew Garrett wrote:
>> On Mon, Jun 06, 2011 at 02:43:46PM -0700, Tony Luck wrote:
>>
>> > Does someone claim maintainership of  drivers/firmware/efivars.c for part3?
>>
>> I think that'd be Matt.
>
> I'm out of the office this week and next, and haven't looked at it
> closely.  Mike Waychison has done most of the editing in there
> recently, I'd be happy if he wishes to be considered the maintainer
> thereof.

I'm out of the office too until next Tuesday.  I should be able to
look at this between now and mid next-week.

>
> Thanks,
> Matt
>
> --
> Matt Domsch
> Technology Strategist
> Dell | Office of the CTO
>
