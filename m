Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab3AGWvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:51:05 -0500
Received: from mail131.messagelabs.com ([216.82.242.99]:42056 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab3AGWvC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:51:02 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1357599053!22836095!9
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.8; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>, Lijo Antony <lijo.kernel@gmail.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 7 Jan 2013 16:50:55 -0600
Subject: RE: [PATCH 2/2] Staging: comedi: addi_common.h: checkpatch.pl fixes
Thread-Topic: [PATCH 2/2] Staging: comedi: addi_common.h: checkpatch.pl fixes
Thread-Index: Ac3tJ/ysKiCz9FZVRL2SZEfNEw3QrQAASnLA
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206D6C98F77@AUSP01VMBX24.collaborationhost.net>
References: <1357395175-6077-1-git-send-email-lijo.kernel@gmail.com>
 <1357395175-6077-2-git-send-email-lijo.kernel@gmail.com>
 <20130107223941.GA3913@kroah.com>
In-Reply-To: <20130107223941.GA3913@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 07, 2013 3:40 PM, Greg KH wrote:
> On Sat, Jan 05, 2013 at 06:12:55PM +0400, Lijo Antony wrote:
>> Reduced line lengths to 80 chars by removing extra spaces.
>> 
>> Signed-off-by: Lijo Antony <lijo.kernel@gmail.com>
>> ---
>>  .../staging/comedi/drivers/addi-data/addi_common.h |   20 ++++++++++----------
>>  1 file changed, 10 insertions(+), 10 deletions(-)

<snip>

> As you didn't do this for all fields in the structure, it's not really
> worth doing it for just these, right?
>
> The proper thing to do is use kerneldoc format and document it all at
> the top of the structure, care to do that instead?

Hopefully I will soon get the rest of the addi-data drivers split off of the
addi_common stuff. This will effectively remove this header file so I'm
not sure it's worth making patches against it.

Regards,
Hartley

