Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab0LVXNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 18:13:32 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40015 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab0LVXNb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 18:13:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hwYgtfeyTEG4BTr9J8R7DqCrRL5GaI21xMmcM4FOXx+27UVBa6aJSKHWpIVbbvvDQf
         vrF4RPFNBHFAin6C+wd8iCexxLa+JLzw9KPvnmuwNPgWk2erA86UU6r0ufEHT5BY8UmK
         JphxU3CggdaDAbtmJL0dwYp+o5rcxMcuvkA3M=
MIME-Version: 1.0
In-Reply-To: <20101222224601.GF30941@bitwizard.nl>
References: <20101220141553.GA6088@bitwizard.nl> <AANLkTikC0gDixPMaj3zZJ9ew7wYx81Ern60omnig-S7c@mail.gmail.com>
 <20101222224601.GF30941@bitwizard.nl>
From: David Rees <drees76@gmail.com>
Date: Wed, 22 Dec 2010 15:13:10 -0800
Message-ID: <AANLkTikbNrBqT2jzSVS6y9FNh+mWoSZDBeJHozN5O05K@mail.gmail.com>
Subject: Re: Slow disks.
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 2:46 PM, Rogier Wolff <R.E.Wolff@bitwizard.nl> wrote:
> On Wed, Dec 22, 2010 at 12:52:08PM -0800, David Rees wrote:
>> On Mon, Dec 20, 2010 at 6:15 AM, Rogier Wolff <R.E.Wolff@bitwizard.nl> wrote:
>> > A friend of mine has a server in a datacenter somewhere. His machine
>> > is not working properly: most of his disks take 10-100 times longer
>> > to process each IO request than normal.
>>
>> I've seen noticeable slowdowns before when the disks were running long
>> SMART tests.  It doesn't seem to affect all drives the same.  The
>> smartctl data you posted didn't say whether or not the disks were
>> currently running a SMART test, but it's worth double checking.
>
> No, the machine has trouble 24/7, I seriously doubt that it would be
> running smart tests 24/7.

It can not hurt to check the status of the disk to be sure...

-Dave
