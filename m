Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab2KEHMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 02:12:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:37730 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab2KEHMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 02:12:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,713,1344236400"; 
   d="scan'208";a="215203044"
Message-ID: <509766DB.9090906@zytor.com>
Date: Mon, 05 Nov 2012 08:12:27 +0100
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
References: <20121102175416.GA11816@srcf.ucam.org> <1351879058.2439.46.camel@dabdike.int.hansenpartnership.com> <20121102180458.GA12052@srcf.ucam.org> <1351899503.2439.49.camel@dabdike.int.hansenpartnership.com> <20121103002244.GC18691@srcf.ucam.org> <1351944236.2417.7.camel@dabdike.int.hansenpartnership.com> <20121103134630.GA28166@srcf.ucam.org> <1351983400.2417.21.camel@dabdike.int.hansenpartnership.com> <20121104042802.GA11295@srcf.ucam.org> <1352020487.2427.5.camel@dabdike.int.hansenpartnership.com> <20121104135251.GA17894@srcf.ucam.org> <87d2zsmv8r.fsf@xmission.com>
In-Reply-To: <87d2zsmv8r.fsf@xmission.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 07:14 AM, Eric W. Biederman wrote:
> 
> In any case the notion that unattended install with no user interaction
> on any uefi machine in any state is complete and total rubbish.  It
> can't be done.  You need power and you need boot media.
> 

That is a hugely different thing from needing a console.

	-hpa


