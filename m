Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab2KEFSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 00:18:35 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58002 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab2KEFSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 00:18:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAJiejCRAZjNWGyJipfprHGptR2051Fdqf-10OkO0Yks7C2dQ0A@mail.gmail.com>
References: <CAJiejCRAZjNWGyJipfprHGptR2051Fdqf-10OkO0Yks7C2dQ0A@mail.gmail.com>
From: Drunkard Zhang <gongfan193@gmail.com>
Date: Mon, 5 Nov 2012 13:18:14 +0800
Message-ID: <CAJiejCTDUubGJ6CN0GepeMJfaofmVwgu-MJ0DZfvbtnXL0dzDg@mail.gmail.com>
Subject: Re: Auto reboot when CPU at full load with X86_ACPI_CPUFREQ
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Config file finally bisected appended, config-3.7.0-rc3+-bad is the
> one leads to reboot, config-3.7.0-rc3+-ok works OK. Hardware info also
> appended.
>
Sorry, I forgot one thing, this bug is CPU specific, with Xeon E5606
or E5620 it's all fine, just triggered with Xeon X5570, or maybe all
Xeon X serial.
