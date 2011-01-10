Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab1AJHuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 02:50:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57578 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1AJHuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 02:50:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=E4OG1TnkEPTv99bVLtT5f1wWSSSGyqndh4mfE7BIDbzOaoJF0eY/x73/tg0gd787oB
         fh7Qu16bfegGi+2D8XPdItxfWTwlFwWJZE1wh0nTGJs8u47prQMbnxoIV5tSmoMZU9jw
         MFVHIteavZCZi3kan79GeZ+5VBeR87XZ7gEmo=
MIME-Version: 1.0
In-Reply-To: <1289164493-9124-1-git-send-email-weil@mail.berlios.de>
References: <1289164493-9124-1-git-send-email-weil@mail.berlios.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 10 Jan 2011 02:49:45 -0500
X-Google-Sender-Auth: VDZXvMEICgHL6NkCYjNBTZRMcdE
Message-ID: <AANLkTinB6_ZywGUEuL9Qk2s9Fmg0En+4eDPrNfy46MaR@mail.gmail.com>
Subject: Re: [PATCH] Blackfin: Fix spelling in unused code (struct name)
To: Stefan Weil <weil@mail.berlios.de>
Cc: Ashish Gupta <asg@thelearninglabs.com>,
        "David S. Miller" <davem@davemloft.net>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 7, 2010 at 16:14, Stefan Weil wrote:
> platfrom -> platform

ive merged into my tree now ... thanks
-mike
