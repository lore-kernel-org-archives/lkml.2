Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab0HWJnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 05:43:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:55922 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab0HWJnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 05:43:17 -0400
Message-ID: <4C724199.5070200@kernel.org>
Date: Mon, 23 Aug 2010 11:38:33 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueue: annotate lock context change
References: <1282486783-4573-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1282486783-4573-1-git-send-email-namhyung@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 23 Aug 2010 09:43:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2010 04:19 PM, Namhyung Kim wrote:
> Some of internal functions called within gcwq->lock context releases and
> regrabs the lock but were missing proper annotations. Add it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

applied to wq#for-linus.  Thanks.

-- 
tejun
