Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab0HJPIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 11:08:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:43898 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932186Ab0HJPId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 11:08:33 -0400
Message-ID: <4C616B24.3070202@kernel.org>
Date: Tue, 10 Aug 2010 17:07:16 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: use INT_MAX as sentinel value of unit_map
References: <1281452283-2911-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1281452283-2911-1-git-send-email-namhyung@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 10 Aug 2010 15:08:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2010 04:58 PM, Namhyung Kim wrote:
> unit_map is a pointer to int so it would be more reasonable to use INT_MAX
> as sentinel value.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Hmmm... yeah unit_map used to be uint.  I'd much prefer -1 (which
would actually result in the same code BTW) over INT_MAX tho.

Thanks.

-- 
tejun
