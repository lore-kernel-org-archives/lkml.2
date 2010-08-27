Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0H0RVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 13:21:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:36683 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385Ab0H0RVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 13:21:19 -0400
Message-ID: <4C77F299.4080004@kernel.org>
Date: Fri, 27 Aug 2010 19:15:05 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, snitzer@redhat.com,
        j-nomura@ce.jp.nec.com, jamie@shareable.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-raid@vger.kernel.org, hch@lst.de
Subject: Re: [PATCHSET 2.6.36-rc2] block, dm: finish REQ_FLUSH/FUA conversion
References: <1282929060-23663-1-git-send-email-tj@kernel.org>
In-Reply-To: <1282929060-23663-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 27 Aug 2010 17:21:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2010 07:10 PM, Tejun Heo wrote:
> The dm conversion is _lightly_ tested.  Please proceed with caution.
> In particular, I haven't tested dm implementation at all.
                                  ^^
				 requested-based dm

-- 
tejun
