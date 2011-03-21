Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab1CUIou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 04:44:50 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:56791 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455Ab1CUIon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 04:44:43 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 21 Mar 2011 09:47:55 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] hid-multitouch: Auto detection of maxcontacts
Message-ID: <20110321084755.GA3784@polaris.bitmath.org>
References: <1300454876-5017-1-git-send-email-benjamin.tissoires@enac.fr>
 <1300454876-5017-2-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1300454876-5017-2-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1Q1air-0004GI-3t.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Q1air-0004GI-3t 736654b7a550d67e3ca5d781517abced
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 02:27:52PM +0100, Benjamin Tissoires wrote:
> This patch enables support of autodetection of maxcontacts.
> When adding support for a new device, one is now able to let
> the device tell how many contacts it supports, or to manually
> set the value if the device happens to provide wrong information.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> Reviewed-by: Stéphane Chatty <chatty@enac.fr>
> ---

Looks ok now. Thank you, Benjamin.

Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Henrik
