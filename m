Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab0FICD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 22:03:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38020 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab0FICD4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 22:03:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A+agQ36ucwGZ8cXQ+N3XKQaGdbFheUmzwY+y5wwMA6TW5WCeAMIrkE1ERrBEnoCF65
         9V9TEyqeoLuykBiPzGAG8V9NHZejvXTWwgf2bPObl9bkHbL5nnfcDzhIrH0flzXxuS+6
         8+YkfES0sEiUnNoj3caL3SClaGEU9uaZt07Nw=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006081855170.4506@i5.linux-foundation.org>
References: <20100608221901.GA25294@srcf.ucam.org>
	<alpine.LFD.2.00.1006081806040.4506@i5.linux-foundation.org>
	<20100608182456.3e681359@virtuousgeek.org>
	<alpine.LFD.2.00.1006081855170.4506@i5.linux-foundation.org>
Date: Wed, 9 Jun 2010 12:03:55 +1000
Message-ID: <AANLkTin45ibtZoThRwOG3eTjFmT0LJ4gKS-ExXqpKx2v@mail.gmail.com>
Subject: Re: [GIT PULL] x86 platform driver updates for 2.6.35-rc3
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 11:57 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 8 Jun 2010, Jesse Barnes wrote:
>>
>> FWIW this is the "make ironlake go fast" driver.  It interacts with the
>> i915 driver to increase graphics performance significantly.  But yeah,
>> Matthew and I didn't get it integrated into his tree in time for the
>> merge window, so I understand if you don't want it right now.
>
> I'm not great at all the intel code-names. Is ironlake the expected-Q4
> on-die GPU or the current one?
>
> Not that I'd prefer to pull it even if it's the current one, but if it's
> the next-gen one then we're in even less of a hurry, I think.
>

Its probably the one on your desk, its at least the one in the two
laptops on mine.

So definitely now-gen.

Dave.
