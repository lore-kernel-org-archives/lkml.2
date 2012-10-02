Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab2JBJFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 05:05:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40445 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab2JBJFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 05:05:41 -0400
MIME-Version: 1.0
In-Reply-To: <1349166910-15726-1-git-send-email-ming.lei@canonical.com>
References: <1349166910-15726-1-git-send-email-ming.lei@canonical.com>
Date: Tue, 2 Oct 2012 17:05:39 +0800
Message-ID: <CACVXFVP8-34XwPLmF63cO2--k-iEFuLhQGVDAbB6U5vhTbpPCA@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: cancel uncache work before caching firmware
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 4:35 PM, Ming Lei <ming.lei@canonical.com> wrote:
> ---
>  drivers/base/firmware_class.c |   30 ++++++++++++++++++++++++------
>  1 file changed, 24 insertions(+), 6 deletions(-)

Please ignore the buggy patch, sorry for the noise.


Thanks,
--
Ming Lei
