Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1EBG77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 02:59:59 -0400
Received: from smtp-out.google.com ([74.125.121.67]:42530 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab1EBG74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 02:59:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=muBFf6mFn5GXOpJBGjIQKkq4uJ6LrtM3I8CYmoaLQH5tiud9zGlL5BRkDPSm/cgpio
         sk4a796f7puz9rYQIGsA==
MIME-Version: 1.0
In-Reply-To: <20110502053735.68CF01537B0@gemini.denx.de>
References: <1304284213-11950-1-git-send-email-ccross@android.com>
	<1304284213-11950-2-git-send-email-ccross@android.com>
	<20110502053735.68CF01537B0@gemini.denx.de>
Date: Sun, 1 May 2011 23:59:51 -0700
X-Google-Sender-Auth: ww854Ax5EgCWLs7GCUoVsKY66hU
Message-ID: <BANLkTinDRMFGsgrbXjwXbimu2KtuGxOKgQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] ARM: tegra: irq: convert to gic arch extensions
From: Colin Cross <ccross@android.com>
To: Wolfgang Denk <wd@denx.de>
Cc: lakml <linux-arm-kernel@lists.infradead.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Erik Gilling <konkers@android.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 1, 2011 at 10:37 PM, Wolfgang Denk <wd@denx.de> wrote:
> Dear Colin Cross,
>
> In message <1304284213-11950-2-git-send-email-ccross@android.com> you wrote:
>> Replace the ugly hack that inserts legacy irq controller calls
>> into the irq call paths by reading and replacing the gic irq
>> chip with the new gic arch extensions.
> ...
>> - * Copyright (C) 2010 Google, Inc.
>> + * Copyright (C) 2011 Google, Inc.
>
> Sorry for nitpicking, but should this not be "(C) 2010-2011" instead?
> You don't want to revoke the 2010 rights on the code, do you?

You're right, I'll fix it.
