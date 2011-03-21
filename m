Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab1CUI7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 04:59:07 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:56354 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754Ab1CUI7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 04:59:05 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 21 Mar 2011 10:02:40 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/5] hid-multitouch: refactor initialization of
 ABS_MT_ORIENTATION
Message-ID: <20110321090240.GD3784@polaris.bitmath.org>
References: <1300454876-5017-1-git-send-email-benjamin.tissoires@enac.fr>
 <1300454876-5017-5-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1300454876-5017-5-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1Q1awt-0008Qr-4m.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Q1awt-0008Qr-4m 3123b8d5f29b86ae370674a79b446e26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 02:27:55PM +0100, Benjamin Tissoires wrote:
> No semantic changes, it's just easier to read the code.

Please augment this commit message.

> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> Reviewed-by: Stéphane Chatty <chatty@enac.fr>
> ---

Thanks,
Henrik
