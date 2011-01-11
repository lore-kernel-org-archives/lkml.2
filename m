Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab1AKRgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 12:36:10 -0500
Received: from csmtp3.one.com ([91.198.169.23]:45799 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab1AKRgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 12:36:08 -0500
From: "Henrik Rydberg" <rydberg@bitmath.org>
Date: Tue, 11 Jan 2011 18:35:53 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hid-multitouch: changes from the review process
Message-ID: <20110111173511.GA3461@polaris.bitmath.org>
References: <1294760754-7885-1-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294760754-7885-1-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 04:45:54PM +0100, Benjamin Tissoires wrote:
> * amended Kconfig (PixCir and Hanvon are the same panel but with
>   different name)
> * insert field name in mt_class and retrieving it in mt_probe
> * add 2 quirks: MT_QUIRK_VALID_IS_INRANGE, MT_QUIRK_VALID_IS_CONFIDENCE,
>   in order to find the field "valid"
> * inlined slot_is_contactid and slot_is_contact_number
> * cosmetics changes (tabs and comments)
> * do not send unnecessary properties once the touch is up
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>

There are some syntactic suboptimalities in the resulting file that
perhaps could be fixed, but content-wise, I have nothing further. So,
given that it actually works,

Acked-by: Henrik Rydberg <rydberg@euromail.se>

Thank you very much for your work, Benjamin.

Henrik
