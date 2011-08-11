Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab1HKRwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:52:08 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:34307 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314Ab1HKRwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:52:04 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=pmgP8lociU8A:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=azj6Gt-4AAAA:8 a=YORvzBCaAAAA:8 a=W0vUJOdyAAAA:8 a=PZfq-FPGQo1XFE9m-lwA:9 a=A9BfQROEsJzYu0BuQnMA:7 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=jbrJJM5MRmoA:10 a=eJ1lpvm07AkA:10 a=VV2__AUApEoA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: <linux-kernel@vger.kernel.org>, <joakim.tjernlund@transmode.se>,
        <akpm@linux-foundation.org>, <linux@horizon.com>,
        <fzago@systemfabricworks.com>, "George Spelvin" <linux@horizon.com>
Subject: [patch v5 resending 0/8] Add slicing-by-8 to crc32
Date: Thu, 11 Aug 2011 12:52:01 -0500
Message-ID: <014801cc584f$5ff90e00$1feb2a00$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcxYTpnfBpxqkyAgTIOmEvcESo/MDg==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending the patch series by hand. I have been having a lot of problems
trying to
Figure out how to make quilt and thunderbird play together. Please let me
Know of this one is better. I have never been able to get quilt to
Make a mbox that my thunderbird likes but Frank has been able to do it.
The last time I imported a mbox into thunderbird as Unsent Messages and then
Edited each note and typed send but for some reason there was a lot of
breakage.
This time I just used the external editor to read in each patch from the
patches
Directory one a time.

[G.S.] Sorry but I managed to leave you off the list. They are out there in
case you
Don't subscribe to the whole list.

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Bob Pearson
> Sent: Wednesday, August 10, 2011 5:43 PM
> To: linux-kernel@vger.kernel.org; joakim.tjernlund@transmode.se;
> akpm@linux-foundation.org; linux@horizon.com;
> fzago@systemfabricworks.com
> Subject: [patch v5 0/8] Add slicing-by-8 to crc32
> 
> Changes for v5 (and hopefully last version)
> 	- added expanded version of document
> 	- added pointers to replace 2D table
> 	  references inside of loops
> 
> Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

