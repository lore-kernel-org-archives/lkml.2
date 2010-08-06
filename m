Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761324Ab0HFMty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 08:49:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:33738 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760735Ab0HFMti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 08:49:38 -0400
Message-ID: <4C5C04D8.1080103@kernel.org>
Date: Fri, 06 Aug 2010 14:49:28 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] percpu: remove address_space attribute if !SMP
References: <1281098768-5724-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1281098768-5724-1-git-send-email-namhyung@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 12:49:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2010 02:46 PM, Namhyung Kim wrote:
> percpu data has no special meaning in case of !CONFIG_SMP.
> This removes lots of sparse warnings.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

But they should still be accessed through the accessors and if they
are accessed through accessors, there shouldn't be sparse warnings
regarding them.  Maybe UP accessors are missing proper markups?  Do
those warnings only happen on UP config?

-- 
tejun
