Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab0LEXwV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 18:52:21 -0500
Received: from smtp-out.google.com ([216.239.44.51]:57675 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab0LEXwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 18:52:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=cb0bKTuRNfQ/4trPc2CchcpOXXKgFViFtT4xd37VcMDynBNMtRigaTDt5vXid+hObt
         3DY3VoOUmg1hh4lpbWwQ==
MIME-Version: 1.0
In-Reply-To: <20101205233021.GA22824@n2100.arm.linux.org.uk>
References: <1291590548-7341-1-git-send-email-ccross@android.com>
	<1291590548-7341-3-git-send-email-ccross@android.com>
	<20101205233021.GA22824@n2100.arm.linux.org.uk>
Date: Sun, 5 Dec 2010 15:52:18 -0800
X-Google-Sender-Auth: qgo9ludSPwTAS-99s7LYKB9IoUw
Message-ID: <AANLkTikY2R8KfdR2EU9TNhPi57PPfQ4ibXnzb=_hp9Fg@mail.gmail.com>
Subject: Re: [PATCH 02/21] ARM: gic: Add functions to save and restore gic state
From: Colin Cross <ccross@android.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Gary King <gking@nvidia.com>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 5, 2010 at 3:30 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Dec 05, 2010 at 03:08:49PM -0800, Colin Cross wrote:
>> on systems with idle states which power-gate the logic including
>> the gic, such as tegra, the gic distributor needs to be shut down
>> and restored on entry and exit from the architecture idle code
>
> This clashes with the GIC cleanups I've previously posted.

Yes, I mentioned that in the patch set overview.  I wanted to get the
concept out there for review, I'll fix it up and repost it once your
patches are final before submitting anything to the patch system.
