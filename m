Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0HWRRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:17:19 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52640 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab0HWRRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:17:18 -0400
Message-ID: <4C72AD0D.7040100@cs.helsinki.fi>
Date: Mon, 23 Aug 2010 20:17:01 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [S+Q Cleanup4 0/6] SLUB: Cleanups V4
References: <20100820173711.136529149@linux.com>
In-Reply-To: <20100820173711.136529149@linux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.8.2010 20.37, Christoph Lameter wrote:
> I think it may be best to first try to merge these and make sure that
> they are fine before we go step by step through the unification patches.
> I hope they can go into -next.

I've applied these patches and queued them for -next. Thanks guys!
