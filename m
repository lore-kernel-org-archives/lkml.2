Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2CSUwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:52:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:56600 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab2CSUwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:52:41 -0400
Message-ID: <4F679C8C.70002@windriver.com>
Date: Mon, 19 Mar 2012 15:52:28 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [PATCH 1/4] kgdb: x86: Return all segment registers also in 64-bit
 mode
References: <cover.1331900215.git.jan.kiszka@siemens.com> <04b93bdc9d3d8ea89dc42adf055ce1c0787bb91f.1331900215.git.jan.kiszka@siemens.com> <4F636307.1050404@windriver.com> <4F673A20.9020505@siemens.com>
In-Reply-To: <4F673A20.9020505@siemens.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 08:52 AM, Jan Kiszka wrote:
> On 2012-03-16 16:57, Jason Wessel wrote:
> The rest should be fine.   I can test this and add it to the merge queue with the NUMREGBYTES change, unless you disagree.
> I don't disagree. :)

Sounds fine.  I added this to the merge queue for the 3.4 kernel.

Cheers,
Jason.
