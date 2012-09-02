Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab2IBIqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 04:46:18 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:45669 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab2IBIqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 04:46:16 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkZyAKUcQ1BV5qoUPGdsb2JhbABFij+vXgR/GQEBAQEeGQ0ngiABAQQBOhwjBQsIAw44FCUKGogaCrpYFIszhglgA5VYhW+NEQ
X-IronPort-AV: E=Sophos;i="4.80,355,1344204000"; 
   d="scan'208";a="401310327"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 2 Sep 2012 10:52:11 +0200
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 16/20] HID: Only dump input if someone is listening
Message-ID: <20120902085211.GA604@polaris.bitmath.org>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
 <1346528835-363-17-git-send-email-rydberg@euromail.se>
 <alpine.LNX.2.00.1209020927130.20709@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1209020927130.20709@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> I have applied this one right away, so you can drop it from your series. 
> The remaining ones I am still about to review (currently travelling).

Great, thanks. The notification callback can also be applied if you want.

> There is no inter-dependency between the Input and HID ones, and so we can 
> handle them with Dmitry as two independent Input and HID series, right?

Not quite, I am afraid. Some of the overlap has disappeared, true.
However, the hid-multitouch patches depend on new variables defined in
the input-mt patches, which in turn depend on the input core
changes. The hid-multitouch patches will apply (with a tiny merge
conflict), but they will not compile.

I can split the input-core and hid-core changes into separate sets,
and those could be applied separately. The input-mt and bcm5974 will
then build on input-core, and hid-multitouch will build on both
input-core and hid-core. I am not sure if this helps anyone, though.

Thanks,
Henrik
