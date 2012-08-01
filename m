Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab2HAVYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 17:24:36 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:8263 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab2HAVYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 17:24:35 -0400
X-Authority-Analysis: v=2.0 cv=QrvcLCOd c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=Q37AcrJXvGoA:10 a=05ChyHeVI94A:10 a=8nJEP1OIZ-IA:10 a=ayC55rCoAAAA:8 a=L6c_SFzkAAAA:8 a=Fc5sQxEOCwUbM_QaLeUA:9 a=wPNLvfGTeEIA:10 a=_sQgkpRUf9EA:10 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <50199E91.5040308@cfl.rr.com>
Date: Wed, 01 Aug 2012 17:24:33 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: MODULE_LICENSE("GPL")??
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What would happen if NVIDIA used this define in their proprietary driver? I 
ask because I am currently in a situation where I believe I may be about to 
use a product that may be doing this very thing. We had to sign a license 
agreement to get the kernel driver source for this product. What we 
received contained the kernel driver source and user land library stuff. 
The source code for the kernel driver has MODULE_LICENSE("GPL") defined. 
The only license info in the package received was NOT the GPL license.

On this particular vendors web site they offer unrestricted downloads of 
binary packages for their product/s that are for specific DIST kernels. But 
to get the source requires signing a license agreement that is NOT GPL.

Thanks
