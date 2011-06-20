Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab1FTW1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:27:32 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64187 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab1FTW1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:27:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xR6yH9syER/N5AmV9E+xBvHs2KuwArXrHACYZEY9OMTdgtRjh80p2KFkuL5/XLgAkL
         AnAP2jfQH+uPEvUHntT+wSLu8/QnBtTfQf+rHpLn/DIVh0U7TVfe0FsAO49RAoaZh8vY
         Wid4JzTCCO1bKGdu/maxPm8KtusPl+B9roEqA=
MIME-Version: 1.0
In-Reply-To: <BANLkTin2f2Dn9onaazgxtkC2kWLrj6cOnw@mail.gmail.com>
References: <1307389135-8150-1-git-send-email-mjg@redhat.com>
	<1307389135-8150-2-git-send-email-mjg@redhat.com>
	<BANLkTinHYQ14A7vzTxA1c2frxUVE6HWNQg@mail.gmail.com>
	<BANLkTimESgP1FMzP8cbKcECLSbEY9Mj3bQ@mail.gmail.com>
	<20110606214735.GA4026@srcf.ucam.org>
	<20110610040012.GA14233@auslistsprd01.us.dell.com>
	<BANLkTin2f2Dn9onaazgxtkC2kWLrj6cOnw@mail.gmail.com>
Date: Mon, 20 Jun 2011 15:27:29 -0700
X-Google-Sender-Auth: al3zVEGzaT9WY1VIpj1260tBKs8
Message-ID: <BANLkTiniLZFZgnLqdBPubOff9X0mOUN+nA@mail.gmail.com>
Subject: Re: [PATCH 2/3] pstore: Add extra context for writes and erases
From: Tony Luck <tony.luck@intel.com>
To: Mike Waychison <mikew@google.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 12:12 AM, Mike Waychison <mikew@google.com> wrote:
> On Thu, Jun 9, 2011 at 9:00 PM, Matt Domsch <Matt_Domsch@dell.com> wrote:
>> On Mon, Jun 06, 2011 at 10:47:35PM +0100, Matthew Garrett wrote:
>>> On Mon, Jun 06, 2011 at 02:43:46PM -0700, Tony Luck wrote:
>>>
>>> > Does someone claim maintainership of  drivers/firmware/efivars.c for part3?
>>>
>>> I think that'd be Matt.
>>
>> I'm out of the office this week and next, and haven't looked at it
>> closely.  Mike Waychison has done most of the editing in there
>> recently, I'd be happy if he wishes to be considered the maintainer
>> thereof.
>
> I'm out of the office too until next Tuesday.  I should be able to
> look at this between now and mid next-week.

Mike; Did you find time to look at Matthew's efi-for-pstore patches yet?
If we want to hit the 3.1 merge window we should be trying to get these
beaten into shape pretty soon (Linus will presumably declare -rc4 tonight,
so not much time left).

-Tony
