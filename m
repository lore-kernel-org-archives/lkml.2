Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933519Ab1JZQ7C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 12:59:02 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43334 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932889Ab1JZQ7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 12:59:00 -0400
MIME-Version: 1.0
In-Reply-To: <20111026135432.GA31917@thinkpad-t410>
References: <1316555754-25949-1-git-send-email-seth.forshee@canonical.com>
	<20110921153137.GA26436@srcf.ucam.org>
	<20110921161043.GC29983@thinkpad-t410>
	<20111026135432.GA31917@thinkpad-t410>
Date: Wed, 26 Oct 2011 10:58:58 -0600
Message-ID: <CAGdLNWGwXGxJmOd8sKtDps2WpgGUGYvuriHjTQqY7kH_v5DtsA@mail.gmail.com>
Subject: Re: [PATCH 0/6] toshiba_acpi: Cleanup and TOS1900 device support
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>,
        Azael Avalos <coproscefalo@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I managed to find some volunteers with machines that use the GHCI
> interface to do some regression testing for me. They aren't exactly
> older hardware, all of them with TOS6208 and being made within the last
> 2 or 3 years. But it's the best I could do.

Great, I was planing on buying an older laptop from eBay, so I could test
my changes on "older" hardware, I might still get it, "to eat my own
cookies".

>
> None of the machines tested showed any regressions as a result of these
> patches. I also got testing of using the INFO method to read hotkey
> scancodes, and that's working on those machines as well. (I did however
> find that I had to reintroduce the global toshiba_acpi pointer for the
> i8042 filter, since it doesn't have any mechanism for passing private
> data to the callback.)

Great news, hope to see your changes merged Seth


Saludos
Azael


-- 
-- El mundo apesta y vosotros apestais tambien --
