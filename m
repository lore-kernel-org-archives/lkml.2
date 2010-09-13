Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab0IMI2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:28:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:43505 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab0IMI2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:28:39 -0400
Message-ID: <4C8DE086.8040501@kernel.org>
Date: Mon, 13 Sep 2010 10:27:50 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: Dave Chinner <david@fromorbit.com>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH UPDATED] workqueue: add documentation
References: <4C87AE52.70401@kernel.org>	<4C87B101.2080608@kernel.org>	<20100909100229.250900f0@schatten.dmk.lab>	<4C88B55E.90203@kernel.org>	<20100909205056.1ac7989a@schatten.dmk.lab>	<4C8A07B3.1050603@kernel.org>	<20100910162658.254b224a@schatten.dmk.lab>	<4C8A46D9.5020303@kernel.org>	<20100913005151.GB411@dastard>	<4C8DDBEC.3010900@kernel.org> <20100913101643.22a1e7d5@schatten.dmk.lab>
In-Reply-To: <20100913101643.22a1e7d5@schatten.dmk.lab>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 13 Sep 2010 08:27:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 10:16 AM, Florian Mickler wrote:
>> +For an unbound wq, the above concurrency management doesn't apply and
>> +the gcwq for the pseudo unbound CPU tries to start executing all work
>> +items as soon as possible.  The responsibility of regulating
>> +concurrency level is on the users.  There is also a flag to mark a
>> +bound wq to ignore the concurrency management.  Please refer to the
>> +Workqueue Attributes section for details.
> 
> renamed to "API section" 

Updated, thanks.

-- 
tejun
