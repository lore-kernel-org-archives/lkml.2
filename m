Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab2ADIyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 03:54:06 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34081 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab2ADIx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 03:53:59 -0500
Message-ID: <4F0413A6.4060704@gmail.com>
Date: Wed, 04 Jan 2012 09:53:58 +0100
From: =?ISO-8859-15?Q?Sven_K=F6hler?= <sven.koehler@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111116 Thunderbird/8.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: microcode should perform update after suspend to disk
References: <jdq23r$vni$1@dough.gmane.org> <4F03ECAF.4080207@linux.vnet.ibm.com>
In-Reply-To: <4F03ECAF.4080207@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.01.2012 07:07, schrieb Srivatsa S. Bhat:
> Which kernel version are you using?

I was using 3.1.4 or something. However, I updated to 3.1.7 lately.
Sorry, I should have mentioned that.

> I tried doing suspend-to-ram and suspend-to-disk on latest kernel (3.2-rc7+)
> and I saw exactly the same messages getting emitted from the microcode
> module in both cases. Not sure what is going wrong in your case...

I'm absolutely puzzled, cause I just tried to reproduce it again, and
microcode was updated successfully during resume from suspend to disk. I
apologize for the noise.


Regards,
  Sven
