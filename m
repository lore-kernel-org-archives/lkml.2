Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab2K0Tom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 14:44:42 -0500
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:36878 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab2K0Tol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 14:44:41 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ajh3ABEXtVBV5qjOPGdsb2JhbABFhUAiAYUAtToXAwEBAQE4NIIeAQEEATocEwEPBQsIAxguFA0YChoTh3sDCQqvfoZhDYlUFIs9aYNgYQOULIFUhXuDUIFqiAE
X-IronPort-AV: E=Sophos;i="4.83,330,1352070000"; 
   d="scan'208";a="457556527"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 27 Nov 2012 20:45:43 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] HID: hid-input factorize hid_input allocation
Message-ID: <20121127194543.GA774@polaris.bitmath.org>
References: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
 <1353684694-5723-2-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353684694-5723-2-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Fri, Nov 23, 2012 at 04:31:24PM +0100, Benjamin Tissoires wrote:
> This just refactors the allocation of hid_input.

I think "breaks out the allocation" would be a more appropriate description.

> No semantic changes.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-input.c | 61 +++++++++++++++++++++++++++----------------------
>  1 file changed, 34 insertions(+), 27 deletions(-)

    Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
