Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab0FOAF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 20:05:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44777 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab0FOAFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 20:05:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 15 Jun 2010 02:05:43 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] ieee1394: sbp2: remove unused code
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <4C16AECD.50506@gmail.com>
Message-ID: <tkrat.0ef352b3c2fae897@s5r6.in-berlin.de>
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
 <1276547208-26569-8-git-send-email-justinmattock@gmail.com>
 <tkrat.6f2ad8e8a9e281c2@s5r6.in-berlin.de> <4C16AECD.50506@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Jun, Justin P. Mattock wrote:
> drivers/ieee1394/raw1394.c: In function 'arm_lock64':
> drivers/ieee1394/raw1394.c:1373:11: warning: 'old' may be used 
> uninitialized in this function
> drivers/ieee1394/raw1394.c: In function 'arm_lock':
> drivers/ieee1394/raw1394.c:1155:12: warning: 'old' may be used 
> uninitialized in this function

Thanks.  I briefly looked at this and am not sure if this is real or a
false positive.  This code is old crud that is really hard to read.

I will look at it again at a more convenient time of day.
-- 
Stefan Richter
-=====-==-=- -==- -====
http://arcgraph.de/sr/

