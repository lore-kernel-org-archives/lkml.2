Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab2LQLLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 06:11:44 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37788 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2LQLLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 06:11:43 -0500
MIME-Version: 1.0
In-Reply-To: <CAHdPZaPQNQ1WS5Qkb4FpmmOX7mXL10HsdaXf5dctp2hd2T0Sow@mail.gmail.com>
References: <20686.63778.840426.61474@pilspetsen.it.uu.se>
	<CAHdPZaPQNQ1WS5Qkb4FpmmOX7mXL10HsdaXf5dctp2hd2T0Sow@mail.gmail.com>
Date: Mon, 17 Dec 2012 06:11:42 -0500
Message-ID: <CAHdPZaO5FjE0oRKtmfkmjJMPYgUxwoOpN-5gzW8-LqznzqVocw@mail.gmail.com>
Subject: Re: [3.7.0 regression] rt2x00lib_probe_dev: Error - Failed to
 initialize hw
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am seeing this line actually when i do vim +389 net/wireless/core.c.
>
>                 u16 all_iftypes = 0;
>
> its good if you tell us the top sha1 of yours?

i am sorry, btw mine's at a4f1de176614f634c367e5994a7bcc428c940df0.
