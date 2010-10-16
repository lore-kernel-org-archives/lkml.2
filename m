Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab0JPB2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 21:28:51 -0400
Received: from smtp-out.google.com ([74.125.121.35]:8006 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab0JPB2u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 21:28:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EfnnN0umNIIQVbuYu7NXKuwMTtNZQzIALTYdJwkpEtr48zeiHwfZJw+NXWgPBthk6X
         IhpUAzar/z03DBRNrSeQ==
MIME-Version: 1.0
In-Reply-To: <201010160036.17653.rjw@sisk.pl>
References: <201010160036.17653.rjw@sisk.pl>
Date: Fri, 15 Oct 2010 18:28:42 -0700
Message-ID: <AANLkTimXXERRCYEjzQbcii6XW8wbjNfN-eWigU7Wi_Lv@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Convert to new PCI PM framework
From: Paul Stewart <pstew@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 3:36 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The ath9k driver uses the legacy PCI power management (suspend
> and resume) callbacks that apparently cause intermittent problems
> to happen (the adapter sometimes doesn't resume correctly on my
> Acer Ferrari One).  Make it use the new PCI PM and let the PCI core
> code handle the PCI-specific details of power transitions.
I'm curious.  What sort of behavior did you get when the device fails
to resume correctly?  Every now and then I've been getting bad
accesses to 0x7000 every now and then -- after that any reads to PCI
registers return all f's.

--
Paul
