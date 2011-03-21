Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab1CUJCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 05:02:05 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:57784 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752422Ab1CUJCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 05:02:04 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 21 Mar 2011 10:05:33 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] hid-multitouch: migrate 3M PCT touch screens to
 hid-multitouch
Message-ID: <20110321090533.GE3784@polaris.bitmath.org>
References: <1300454876-5017-1-git-send-email-benjamin.tissoires@enac.fr>
 <1300454876-5017-6-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1300454876-5017-6-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1Q1azf-00015V-4n.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Q1azf-00015V-4n e39bdf280fb105c4cfe2354e59b9f5b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Fri, Mar 18, 2011 at 02:27:56PM +0100, Benjamin Tissoires wrote:
> This patch merges the hid-3m-pct driver into hid-multitouch.
> To keep devices working the same way they used to with hid-3m-pct,
> we need to add two signal/noise ratios for width and height.
> We also need to work on width/height to send proper
> ABS_MT_ORIENTATION flag.
> 
> Importing 3M into hid-multitouch also solved the bug in which
> devices handling width and height in their report descriptors
> did not show ABS_MT_TOUCH_MAJOR and ABS_MT_TOUCH_MINOR.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> Reviewed-by: Stéphane Chatty <chatty@enac.fr>
> ---

The patch _looks_ good, but I have problems getting this to work on a
3M2256. What devices were this one tested on so far?

Henrik
