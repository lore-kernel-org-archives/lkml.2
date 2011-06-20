Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab1FTWaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:30:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34202 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab1FTWa3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:30:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vM8S/571pWvN2wlbJG3qWYoBJaD5srvfQUiXu3QHp4YKtJe9yK4DBmAS4raQuthaZe
         RClbN7v4aTlXnBL+xYZg==
MIME-Version: 1.0
In-Reply-To: <BANLkTiniLZFZgnLqdBPubOff9X0mOUN+nA@mail.gmail.com>
References: <1307389135-8150-1-git-send-email-mjg@redhat.com>
 <1307389135-8150-2-git-send-email-mjg@redhat.com> <BANLkTinHYQ14A7vzTxA1c2frxUVE6HWNQg@mail.gmail.com>
 <BANLkTimESgP1FMzP8cbKcECLSbEY9Mj3bQ@mail.gmail.com> <20110606214735.GA4026@srcf.ucam.org>
 <20110610040012.GA14233@auslistsprd01.us.dell.com> <BANLkTin2f2Dn9onaazgxtkC2kWLrj6cOnw@mail.gmail.com>
 <BANLkTiniLZFZgnLqdBPubOff9X0mOUN+nA@mail.gmail.com>
From: Mike Waychison <mikew@google.com>
Date: Mon, 20 Jun 2011 15:29:51 -0700
Message-ID: <BANLkTinw72Xabag9871=qsWsxO0xc78ZNVdJ+nyBwTQjkVbJ3A@mail.gmail.com>
Subject: Re: [PATCH 2/3] pstore: Add extra context for writes and erases
To: Tony Luck <tony.luck@intel.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 3:27 PM, Tony Luck <tony.luck@intel.com> wrote:
> On Fri, Jun 10, 2011 at 12:12 AM, Mike Waychison <mikew@google.com> wrote:
>> On Thu, Jun 9, 2011 at 9:00 PM, Matt Domsch <Matt_Domsch@dell.com> wrote:
>>> On Mon, Jun 06, 2011 at 10:47:35PM +0100, Matthew Garrett wrote:
>>>> On Mon, Jun 06, 2011 at 02:43:46PM -0700, Tony Luck wrote:
>>>>
>>>> > Does someone claim maintainership of  drivers/firmware/efivars.c for part3?
>>>>
>>>> I think that'd be Matt.
>>>
>>> I'm out of the office this week and next, and haven't looked at it
>>> closely.  Mike Waychison has done most of the editing in there
>>> recently, I'd be happy if he wishes to be considered the maintainer
>>> thereof.
>>
>> I'm out of the office too until next Tuesday.  I should be able to
>> look at this between now and mid next-week.
>
> Mike; Did you find time to look at Matthew's efi-for-pstore patches yet?
> If we want to hit the 3.1 merge window we should be trying to get these
> beaten into shape pretty soon (Linus will presumably declare -rc4 tonight,
> so not much time left).
>

My bad.  This fell off my plate :(   Looking now.
