Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1A1HbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 02:31:24 -0500
Received: from lo.gmane.org ([80.91.229.12]:53040 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab1A1HbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 02:31:22 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] move x86 specific oops=panic to generic code
Date: Fri, 28 Jan 2011 07:31:06 +0000 (UTC)
Message-ID: <ihtrbq$921$1@dough.gmane.org>
References: <20110127221511.GA32313@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 60.247.97.98
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 23:15:11 +0100, Olaf Hering wrote:

> The oops=panic cmdline option is not x86 specific, move it to generic
> code. Update documentation.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> 

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

