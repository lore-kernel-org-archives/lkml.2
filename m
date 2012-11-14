Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423144Ab2KNRrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:47:07 -0500
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:35817 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423096Ab2KNRrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:47:05 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiqkAAPYo1BV5h1yPGdsb2JhbABEhVaFAbdkA4EAGQEBAQEfGQ0ngh4BAQU6HBMBDxAIAxguFA0YChoTh3gDE7FfDYlUFIswaXKEWWEDlCeBVIV7g06BaogB
X-IronPort-AV: E=Sophos;i="4.83,252,1352070000"; 
   d="scan'208";a="445840526"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 14 Nov 2012 18:53:33 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/14] Input: introduce EV_MSC Timestamp
Message-ID: <20121114175333.GA4804@polaris.bitmath.org>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352908766-4492-10-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352908766-4492-10-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 04:59:21PM +0100, Benjamin Tissoires wrote:
> Some devices provides the actual timestamp (hid_dg_scan_time in win8 ones)
> computed by the hardware itself. This value is global to the frame and is
> not specific to the multitouch protocol.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> Reviewed-by: Henrik Rydberg <rydberg@euromail.se>
> ---

Does not directly apply to 3.7 due to the uapi changes, but trivial enough.

Henrik
