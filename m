Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab2KEIxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:53:40 -0500
Received: from mga14.intel.com ([143.182.124.37]:7990 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab2KEIxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:53:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,713,1344236400"; 
   d="scan'208";a="213507793"
Message-ID: <50977E8D.7090204@zytor.com>
Date: Mon, 05 Nov 2012 09:53:33 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
References: <20121102175416.GA11816@srcf.ucam.org> <1351879058.2439.46.camel@dabdike.int.hansenpartnership.com> <20121102180458.GA12052@srcf.ucam.org> <1351899503.2439.49.camel@dabdike.int.hansenpartnership.com> <20121103002244.GC18691@srcf.ucam.org> <1351944236.2417.7.camel@dabdike.int.hansenpartnership.com> <20121103134630.GA28166@srcf.ucam.org> <1351983400.2417.21.camel@dabdike.int.hansenpartnership.com> <20121104042802.GA11295@srcf.ucam.org> <1352020487.2427.5.camel@dabdike.int.hansenpartnership.com> <20121104135251.GA17894@srcf.ucam.org> <87d2zsmv8r.fsf@xmission.com> <509766DB.9090906@zytor.com> <87625kh5r2.fsf@xmission.com> <8582ea67-beda-44e6-82cd-52d73555dda8@email.android.com> <87k3u0cu1k.fsf@xmission.com>
In-Reply-To: <87k3u0cu1k.fsf@xmission.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 09:50 AM, Eric W. Biederman wrote:
> 
> Facts are always a good thing to assume.
> 
> The fact is the general case does not admit an install without user
> interaction.
> 

In the general case, no.  However, that is not a good reason to rule out
the cases where it *can* be done; especially as vendors are starting to
wake up to actual needs of users and of Linux in particular.

	-hpa

