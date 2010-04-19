Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab0DSWs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 18:48:27 -0400
Received: from tundra.namei.org ([65.99.196.166]:44579 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab0DSWsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 18:48:25 -0400
Date: Tue, 20 Apr 2010 08:48:23 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: wzt.wzt@gmail.com
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       eparis@parisplace.org
Subject: Re: [PATCH] Security: Fix the comment of cap_file_mmap()
In-Reply-To: <20100419011617.GB22615@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1004200848120.19387@tundra.namei.org>
References: <20100419011617.GB22615@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Apr 2010, wzt.wzt@gmail.com wrote:

> In the comment of cap_file_mmap(), replace mmap_min_addr to be dac_mmap_min_addr.
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
