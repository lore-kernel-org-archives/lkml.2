Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401Ab1FAP2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 11:28:44 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:33681 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757921Ab1FAP2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 11:28:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Q4DUmqtL0Xe3dnbV5UPgq/y3pL9UaEvOHo0C4lKmmI7pvf2/wLgTeqO0PDBFjLtjml
         GID+os3RyAoi1n4qY0MWFxSJ/95kUSLwIRPogGhQAuALexNnOZNPJ2tFOFnK2gJOVGKD
         i2YfFbGxVXJa3/rUVaVsDoxwQhfl2bKDyOtNU=
MIME-Version: 1.0
In-Reply-To: <1306941256.4405.123.camel@localhost>
References: <1306923407.4405.94.camel@localhost>
	<1306940008-28454-1-git-send-email-bengardiner@nanometrics.ca>
	<1306941256.4405.123.camel@localhost>
Date: Wed, 1 Jun 2011 11:28:41 -0400
Message-ID: <BANLkTimzuZ5URhDj2BxPj3g_YaHmZufWsg@mail.gmail.com>
Subject: Re: [PATCH] UBIFS: fixup merged 'UBIFS: fix-up free space earlier'
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Matthew L. Creech" <mlcreech@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

On Wed, Jun 1, 2011 at 11:14 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Wed, 2011-06-01 at 10:53 -0400, Ben Gardiner wrote:
>> When the patch 'UBIFS: intialize LPT earlier' was massaged before being applied
>> the context of the next patch 'UBIFS: fix-up free space earlier' was muddled
>> sufficiently for the order of allocate-lpt then free-space-fixup was reversed --
>> I think.
>>
>> Put the free-space-fixup after allocate-lpt.
>>
>> Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
>>
>> ---
>> With this fixup applied on-top-of the ubifs-2.6 master I am able to mount a
>> ubinized image containing a UBIFS volume which has the free-space-fixup flag
>> set. No assertions are displayed.
>
> Thanks. Merged this patch to the 3rd one and pushed out.

You're most welcome.

Both branches master and linux-next are working as expected.

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
