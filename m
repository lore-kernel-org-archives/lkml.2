Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab1G1RDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 13:03:38 -0400
Received: from mail.perches.com ([173.55.12.10]:4350 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab1G1RDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 13:03:34 -0400
Subject: Re: [PATCH 0/6] adjust array index
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <1311857165-14780-1-git-send-email-julia@diku.dk>
References: <1311857165-14780-1-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 10:03:33 -0700
Message-ID: <1311872613.10042.12.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 14:46 +0200, Julia Lawall wrote:
> These patches fix cases where the upper bound of a loop is used as an array
> index, while it appears that the loop index should be used as the array
> index.

Good one.

