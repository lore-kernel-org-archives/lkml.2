Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab2DPTZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:25:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:35840 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2DPTZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:25:43 -0400
Message-ID: <4F8C7232.50404@kernel.dk>
Date: Mon, 16 Apr 2012 21:25:38 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Danny Kukawka <danny.kukawka@bisect.de>
Subject: Re: [PATCH] dac960: Remove unused variables from DAC960_CreateProcEntries()
References: <alpine.LNX.2.00.1204162025430.21898@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1204162025430.21898@swampdragon.chaosbits.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-16 20:29, Jesper Juhl wrote:
> The variables 'StatusProcEntry' and 'UserCommandProcEntry' are
> assigned to once and then never used. This patch gets rid of the
> variables.
> 
> While I was there I also fixed the indentation of the function to use
> tabs rather than spaces for the lines that did not already do so.

Thanks, applied.

-- 
Jens Axboe

