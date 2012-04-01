Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab2DAQ0l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:26:41 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:16841 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2DAQ0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:26:39 -0400
Message-ID: <4F7881BD.2050605@tilera.com>
Date: Sun, 1 Apr 2012 12:26:37 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: update EDAC information
References: <20120331100214.GA7256@aftab> <mailman.285955.1333149246.6384.bluesmoke-devel@lists.sourceforge.net> <4F7642A9.2070801@tilera.com> <201203311350.q2VDoO23007327@farm-0012.internal.tilera.com> <20120401092616.GB15717@aftab>
In-Reply-To: <20120401092616.GB15717@aftab>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/1/2012 5:26 AM, Borislav Petkov wrote:
> On Sat, Mar 31, 2012 at 09:46:03AM -0400, Chris Metcalf wrote:
>> The bluesmoke mailing list no longer works, so use
>> linux-edac@vger.kernel.org.  And, use a less restrictive pattern so all
>> drivers/edac changes go to linux-edac as well.
>>
>> Borislav suggested I just push this through the tile tree since there
>> is currently no core edac maintainer (emails to Doug Thompson bounce).
>>
>> Reviewed-by: Borislav Petkov <bp@amd64.org>
>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> Please don't add Reviewed-by tags to a patch which actually hasn't been
> reviewed yet, no matter how trivial it is.

Thanks, will do (or, "won't do", I guess).

I added your Acked-by to the patch and will push through the tile tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

