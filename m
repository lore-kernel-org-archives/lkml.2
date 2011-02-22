Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab1BVPbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 10:31:14 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55762 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab1BVPbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 10:31:12 -0500
MIME-Version: 1.0
X-Originating-IP: [172.22.72.244]
In-Reply-To: <AANLkTi==wykFCCjamRNh2ngEaubgeLqmZ7Mv9OsH=0cL@mail.gmail.com>
References: <1298342392-21236-1-git-send-email-ccross@android.com>
	<1298342392-21236-8-git-send-email-ccross@android.com>
	<AANLkTikNSEyjdL0Lchmm-bFxD00omkGLq6Q6Yyjy51Ov@mail.gmail.com>
	<AANLkTi==wykFCCjamRNh2ngEaubgeLqmZ7Mv9OsH=0cL@mail.gmail.com>
Date: Tue, 22 Feb 2011 07:30:35 -0800
Message-ID: <AANLkTinm70LbG8-H7RHndOzkP9vcnu5GhnhKh_LHSzaP@mail.gmail.com>
Subject: Re: [PATCH 7/7] ARM: tegra: clock: Disable clocks left on by bootloader
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, konkers@android.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mike@compulab.co.il, Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 22, 2011 at 12:05 AM, Colin Cross <ccross@android.com> wrote:

> It doesn't need to be an early_param, I can make it a __setup.

Sounds good.

>> Also, Documentation/kernel-parameters.txt should be updated with it.
> Is it really worth adding every debug flag on every platform to
> kernel-parametes.txt?  I could add the flag to the warning message
> instead.

It looks like most arm sub-archs haven't added theirs, so it's OK to
leave out. I'm not too bothered either way myself.


-Olof
