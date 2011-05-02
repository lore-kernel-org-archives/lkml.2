Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab1EBFhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 01:37:41 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:33618 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1EBFhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 01:37:38 -0400
X-Auth-Info: BOoRyjCql9cYUrWZRXDBHe46reBu3O29NOew0E5Xz0w=
To: Colin Cross <ccross@android.com>
cc: lakml <linux-arm-kernel@lists.infradead.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Erik Gilling <konkers@android.com>
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH 1/4] ARM: tegra: irq: convert to gic arch extensions
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: <1304284213-11950-2-git-send-email-ccross@android.com>
References: <1304284213-11950-1-git-send-email-ccross@android.com> <1304284213-11950-2-git-send-email-ccross@android.com>
Comments: In-reply-to Colin Cross <ccross@android.com>
   message dated "Sun, 01 May 2011 14:10:10 -0700."
Date: Mon, 02 May 2011 07:37:35 +0200
Message-Id: <20110502053735.68CF01537B0@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Colin Cross,

In message <1304284213-11950-2-git-send-email-ccross@android.com> you wrote:
> Replace the ugly hack that inserts legacy irq controller calls
> into the irq call paths by reading and replacing the gic irq
> chip with the new gic arch extensions.
...
> - * Copyright (C) 2010 Google, Inc.
> + * Copyright (C) 2011 Google, Inc.

Sorry for nitpicking, but should this not be "(C) 2010-2011" instead?
You don't want to revoke the 2010 rights on the code, do you?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
It usually takes more than three weeks to prepare  a  good  impromptu
speech.                                                  - Mark Twain
