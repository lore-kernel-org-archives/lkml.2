Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab2IDUdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:33:01 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43644 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab2IDUc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:32:59 -0400
Date: Tue, 4 Sep 2012 21:37:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH 10/11] acpi: Ignore acpi_rsdp kernel parameter in a
 secure boot environment
Message-ID: <20120904213742.0221543e@pyramind.ukuu.org.uk>
In-Reply-To: <CAKocOOOMevXWCPgAddo4scC+GY+emw67XxC3vFnOtJM81QxkTA@mail.gmail.com>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
	<1346774117-2277-11-git-send-email-mjg@redhat.com>
	<CAKocOONvci0Otb9wDgw6he48HkCvvhh+TMrv63AwgZLtmv4_Kg@mail.gmail.com>
	<20120904163829.GA23777@srcf.ucam.org>
	<CAKocOOOMevXWCPgAddo4scC+GY+emw67XxC3vFnOtJM81QxkTA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Gotta say this capability name is confusing. Naming is
> CAP_PRE_SECURE_BOOT or something along the lines might be a better
> choice. When I just look at this name, I sure thought this
> CAP_SECURE_FIRMWARE true means it is a secure boot capable firmware.

Given there is nothing secure about it would it also be better to call it
AUTHENTICATED_BOOT ?

Alan
