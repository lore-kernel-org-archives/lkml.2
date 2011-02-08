Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab1BHN5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:57:39 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35128 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab1BHN5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:57:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uZvmDkteUNj3TpxfJEllObnWCnchQXqp84Kkp8tku83SKG1bxP72XfKDU63kF2iwgv
         WE7yhESSEp3boKAlSmKL+Z1obkqhgQbiKCAefKoZOpUywWQ2AQjTAhm39ZmOsE03r1fz
         vFjEthXEuH4b5arsZkiR3UeoRgwmJ31shYh2E=
MIME-Version: 1.0
In-Reply-To: <20110208133922.6cf8142e@lxorguk.ukuu.org.uk>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
	<20110208122409.19110.4233.sendpatchset@linux-mhg7.site>
	<20110208130701.19709cc6@lxorguk.ukuu.org.uk>
	<AANLkTimAioh_xu0qoQCndSWDAYJ4bpWv01NZn_bZ9g2a@mail.gmail.com>
	<20110208132518.300bb098@lxorguk.ukuu.org.uk>
	<AANLkTimYbC+zgnct9j75WNR7f4M4m2=hYvODUm9mc-3W@mail.gmail.com>
	<20110208133922.6cf8142e@lxorguk.ukuu.org.uk>
Date: Tue, 8 Feb 2011 14:57:37 +0100
Message-ID: <AANLkTik744+r8y1FK9P6-aOcH0OMLyg5nvfJb2ZBVSdv@mail.gmail.com>
Subject: Re: [PATCH 05/20] pata_efar: always program master_data before slave_data
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 2:39 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > That sounds like someone quoting religion. Documentation cite please.
>>
>> s/religion/common sense/
>
> Anyone who programs ATA controllers on the basis of common sense rather
> than documentation, errata sheets and actually testing rather than
> speculating is naïve. In the case of ATA more so than most hardware.

Fully agreed.

> Stil waiting a documentation cite for your otherwise gratuitious and
> untested change

Alan, I'm not doing real-time consulting with you.  The code is
provided in the best effort manner and it most likely will be
underrated (like all ATA/IDE work is) anyway so I do not really care
that much if it will be merged ever.  Once it will be merged it may
only mean more unpaid support time for me since some maintainers are
not doing any real maintenance work these days..   Please at least
respect some of my time spent on all this burdensome silly little
driver differences comparisons and read the whole patch set before
making comments on individual changes (which you certainly haven't
done given timing of your review mails and complexity of changes)..
