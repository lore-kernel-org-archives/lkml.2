Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab1K3Ah7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 19:37:59 -0500
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:53747 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757298Ab1K3Ah5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 19:37:57 -0500
X-Greylist: delayed 1080 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Nov 2011 19:37:56 EST
X-SENDER-IP: [85.230.170.8]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArJqAFt11U5V5qoIPGdsb2JhbABDiUqgIYETGQEBAQE3MoFyAQEEATocEwEPBQsIA0YUJQoaE4gFArdZEoopYwSMbCeHQIVVjD4
X-IronPort-AV: E=Sophos;i="4.69,594,1315173600"; 
   d="scan'208";a="225900351"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 30 Nov 2011 01:19:56 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] last merge in hid-multitouch
Message-ID: <20111130001956.GA3276@polaris.bitmath.org>
References: <1322568792-4432-1-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322568792-4432-1-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here are some multitouch updates.
> The first one is the last merge to handle all win7 compliant multitouch
> devices in hid-multitouch (finally, we've got it!).
> The others are the migration to input_register to allocate items before
> the input is ready, and another VID/PID.

I believe Stephane owes you a beer now. ;-)

    Acked-by: Henrik Rydberg <rydberg@euromail.se>

Thanks, Benjamin.

Henrik
