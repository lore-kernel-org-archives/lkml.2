Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab1AaKyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:54:43 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:36305 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754022Ab1AaKym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:54:42 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 31 Jan 2011 11:55:26 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/4] hid-multitouch work
Message-ID: <20110131105526.GA1551@polaris.bitmath.org>
References: <1296469702-3710-1-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296469702-3710-1-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.192.164
X-Scan-Result: No virus found in message 1PjrOg-0006QD-Au.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PjrOg-0006QD-Au 9e442edd609d0fb4bb281ea1a8f84a52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 11:28:18AM +0100, Benjamin Tissoires wrote:
> Hi guys,
> 
> here is the v2 of the work on hid-multitouch sent last friday.
> I just split the former first patch and remove the MT_CLS_DUAL_DEFAUT stuff.

Excellent. You may want to add at least one sentence in the commit
message of patch 3, but other than that,

Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

on all four of them. Thank you Benjamin.

Henrik
