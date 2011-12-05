Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab1LEM3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:29:38 -0500
Received: from broadrack.ru ([195.178.208.66]:34476 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932142Ab1LEM3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:29:37 -0500
Date: Mon, 5 Dec 2011 15:29:31 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Hubert Feurstein <h.feurstein@gmail.com>
Cc: jeff.dagenais@gmail.com, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH v2] w1: add fast search for single slave bus
Message-ID: <20111205122931.GA1550@ioremap.net>
References: <258EF057-8FF6-4432-A9E5-77F87607C45F@gmail.com>
 <1323017210-14666-1-git-send-email-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323017210-14666-1-git-send-email-h.feurstein@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Dec 04, 2011 at 05:46:50PM +0100, Hubert Feurstein (h.feurstein@gmail.com) wrote:
> This enables a much more efficient way of device searching. It uses the
> 1-wire read-rom operation which allows the direct reading of the slave
> address. BUT this works only with exactly one slave on the bus.

Looks good to me, thank you!
Greg, please pull it into your tree

> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
