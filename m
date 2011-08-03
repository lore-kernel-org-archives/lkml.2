Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1HCAtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 20:49:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44357 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab1HCAtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 20:49:13 -0400
Message-ID: <4E389AF9.7040905@zytor.com>
Date: Tue, 02 Aug 2011 17:48:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: "Andrew G. Morgan" <agm@google.com>, Maximilian Attems <max@stro.at>,
        Eric Northup <digitaleric@google.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Eric Paris <eparis@parisplace.org>, klibc@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] run-init: Add drop_capabilities support.
References: <20110719203843.646.73383.stgit@mike2.sea.corp.google.com> <20110719203853.646.50974.stgit@mike2.sea.corp.google.com> <20110729204529.GB3207@stro.at> <CAGTjWtCYb0NOBFsMxWKWEwN-pdOD1fqimHco3nk_N-tKQvxdyQ@mail.gmail.com> <20110802210912.GB20986@stro.at> <CAGTjWtAyCZ9fyBeEcsrSmpzK4Lgae5uyHCfO2LExeYLSrx+4jg@mail.gmail.com> <CABV1ukGS8RN9BGC-TDB5L=yOUc1cUB3OuspGXKGwdwGtCvrZQg@mail.gmail.com> <CAGTjWtC-iGP1RGbE8R9EGEM9X_YeA+2wahmNtcNzcU=sb7EBbw@mail.gmail.com> <CAGTjWtC+e185XcWskviA7B1T=AcdK5kVkpuZkBC-r8xpgcZ2KA@mail.gmail.com>
In-Reply-To: <CAGTjWtC+e185XcWskviA7B1T=AcdK5kVkpuZkBC-r8xpgcZ2KA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 04:37 PM, Mike Waychison wrote:
> 
> Perhaps the right approach is to not drop the effective and permitted
> masks as Andrew pointed out, and do all this from kinit, not from
> run-init while /proc is mounted?
> 

Well, we should really move /proc et al into the new root, if nothing
else to match switch_root.

	-hpa

