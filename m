Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2FEHQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 03:16:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:40790 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab2FEHQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 03:16:38 -0400
Message-ID: <4FCDB24A.6000002@kernel.dk>
Date: Tue, 05 Jun 2012 09:16:26 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Asai Thambi S P <asamymuthupa@micron.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 1/2] mtip32xx: Remove 'registers' and 'flags' from sysfs
References: <4FCD0FC7.9010105@micron.com>
In-Reply-To: <4FCD0FC7.9010105@micron.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 09:43 PM, Asai Thambi S P wrote:
> 
> This patch removes entries 'registers' and 'flags' from sysfs. Updated
> ABI file to reflect this change.

Applied, thanks.

-- 
Jens Axboe

