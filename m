Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab1HXWKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:10:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33879 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1HXWKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:10:37 -0400
Message-ID: <4E5576CF.2050905@zytor.com>
Date: Wed, 24 Aug 2011 15:10:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: base support for the TS-5500 platform
References: <1314217407-31249-1-git-send-email-vivien.didelot@savoirfairelinux.com> <1314217407-31249-2-git-send-email-vivien.didelot@savoirfairelinux.com> <4E55670F.90102@zytor.com> <20110824180837.6841f3d8@v0nbox>
In-Reply-To: <20110824180837.6841f3d8@v0nbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 03:08 PM, Vivien Didelot wrote:
> Indeed this will be run on any Elan SC520 based platforms if the user
> has asked for TS-5500 support in the menuconfig. I could add checks for
> other hardware such as the Ethernet controller, but it would require
> including pci headers and delaying the initcall (using late_initcall
> instead of postcore_initcall).
> That's why I think it is not really worth adding more tests. They
> could be added later in this function if there is really a need.
> 
> Regards,
> Vivien.

Hello?  HELLO?

We do not break unrelated hardware just because something is enabled at
compile time.

EVER.

	-hpa
