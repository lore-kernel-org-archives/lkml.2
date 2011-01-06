Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1AFQ2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:28:35 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:57604 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751281Ab1AFQ2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:28:34 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 6 Jan 2011 17:28:15 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 02/10] hid: set HID_MAX_FIELD at 128
Message-ID: <20110106162815.GC1790@polaris.bitmath.org>
References: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
 <1294248468-19979-3-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294248468-19979-3-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PashD-0001ZU-84.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PashD-0001ZU-84 53aa18debda32c31ceb0fdcd344c67a0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 06:27:40PM +0100, Benjamin Tissoires wrote:
> Stantums multitouch panels sends more than 64 reports and this results
> in not being able to handle all the touches given by this device.
> 
> This patch is required to be able to include Stantum panels in the
> unified hid-multitouch driver.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>

This one could go in anytime, it seems.

Acked-by: Henrik Rydberg <rydberg@euromail.se>

Henrik
