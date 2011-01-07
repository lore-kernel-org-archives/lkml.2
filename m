Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab1AGUF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:05:27 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:54569 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752917Ab1AGUFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:05:25 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 7 Jan 2011 21:03:49 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v3 5/5] hid-mulitouch: added support for the 'Sensing
 Win7-TwoFinger'
Message-ID: <20110107200349.GD29913@polaris.bitmath.org>
References: <1294425762-29730-1-git-send-email-benjamin.tissoires@enac.fr>
 <1294425762-29730-6-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1294425762-29730-6-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PbIXN-0007Rt-8K.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PbIXN-0007Rt-8K 80198876bb483be948c3557527401e28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 07:42:42PM +0100, Benjamin Tissoires wrote:
> Added support for the 'Sensing Win7-TwoFinger' panel by GeneralTouch found on some tablets.
> 
> Because of conflicting VID/PID, this conflicts with previous support for some single-touch panels by GeneralTouch
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> Signed-off-by: Stéphane Chatty <chatty@enac.fr>
> ---

Other than the class proposal from the previous patch, this looks nice.

Thanks,
Henrik
