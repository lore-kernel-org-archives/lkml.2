Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab0CPVqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:46:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42141 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab0CPVp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:45:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ulrich Drepper <drepper@gmail.com>
Subject: Re: ACPI spam
Date: Tue, 16 Mar 2010 22:48:53 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <a36005b51003160819p21871af4t48a08a502afb67b5@mail.gmail.com>
In-Reply-To: <a36005b51003160819p21871af4t48a08a502afb67b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003162248.53820.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCing linux-acpi]

On Tuesday 16 March 2010, Ulrich Drepper wrote:
> On one machine I've used using a recent kernel I see tons of messages like
> 
> Mar 16 10:54:52 intel-d3cf1-01 kernel: ACPI Exception: AE_NOT_EXIST,
> while evaluating GPE method [_L01] (20090903/evgpe-568)
> Mar 16 10:54:53 intel-d3cf1-01 kernel: ACPI Error: No handler for
> Region [ECF2] (ffff88013b69c978) [EmbeddedControl]
> (20090903/evregion-319)
> Mar 16 10:54:53 intel-d3cf1-01 kernel: ACPI Error: Region
> EmbeddedControl(3) has no handler (20090903/exfldio-295)
> 
> This is reported hundreds of times.
> 
> Shouldn't these messages be rate-limited?  Aside from the reason being fixed.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

