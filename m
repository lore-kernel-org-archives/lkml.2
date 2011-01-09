Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab1AINrA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 08:47:00 -0500
Received: from csmtp3.one.com ([91.198.169.23]:33142 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab1AINq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 08:46:58 -0500
From: "Henrik Rydberg" <rydberg@bitmath.org>
Date: Sun, 9 Jan 2011 14:46:52 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Switch turbox/mosart touchscreen to hid-mosart
Message-ID: <20110109134652.GA5299@polaris.bitmath.org>
References: <1294485342-2492-1-git-send-email-benjamin.tissoires@enac.fr>
 <1294485342-2492-2-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294485342-2492-2-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 08, 2011 at 12:15:42PM +0100, Benjamin Tissoires wrote:
> This device used the MULTI_INPUT quirk whereas it could be used
> with hid-mosart instead to support the multitouch part.
> 
> Reference: https://bugs.launchpad.net/ubuntu/+bug/620609/
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> ---
> Hi Jiri,
> 
> This one is in the utouch ppa since Novembre.
> The guy that sent the multi_input quirk was not able to
> test it, but others reported it is ok.
> 
> I think it also can go to stable.

Acked-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
