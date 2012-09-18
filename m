Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2IRVgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 17:36:06 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:60723 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138Ab2IRVgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 17:36:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Subject: Re: [PATCH V3 0/3] PNP: Allow PNP resources to be disabled (interface)
Date: Tue, 18 Sep 2012 23:42:30 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Borislav Petkov <bp@alien8.de>, bhelgaas@google.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <50158321.4030007@gmx.net> <201208022340.16948.rjw@sisk.pl> <5055DFB6.6070809@gmx.net>
In-Reply-To: <5055DFB6.6070809@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209182342.30244.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, September 16, 2012, Witold Szczeponik wrote:
> Hi Rafael, 
> 
> what about the patches 1 and 3 which do not make any changes to the ABI?
> The first patch simplifies the code, while the third patch fixes a problem in
> the PNP resource allocation.  Any chances to have them included in 3.7?

They would be fine as far as I'm concerned, but I'm not maintaining that part
of the kernel (at least at the moment).

I'm not sure who's the maintainer of it, to be honest.

Thanks,
Rafael
