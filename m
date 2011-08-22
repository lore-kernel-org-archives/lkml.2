Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab1HVM2C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 08:28:02 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:48363 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab1HVM1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 08:27:55 -0400
Date: Mon, 22 Aug 2011 14:27:32 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Julia Lawall <julia@diku.dk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        kernel-janitors@vger.kernel.org, linux390@de.ibm.com,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        sumsaha@gmail.com
Subject: Re: [PATCH] arch/s390/kernel/ipl.c: correct error detection check
Message-ID: <20110822122732.GA9280@osiris.boeblingen.de.ibm.com>
References: <1314013594-25651-1-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314013594-25651-1-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 01:46:34PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> reipl_fcp_kset was just initialized, so it appears that it should be tested
> instead of reipl_kset.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> Reported-by: Suman Saha <sumsaha@gmail.com>

Applied. Thanks!
