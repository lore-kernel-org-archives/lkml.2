Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0LAROQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:14:16 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48767 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab0LAROO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:14:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vhf/uM2zY64eEHdKE/9hnLuuyNa77Yc7SSJcxXa1CmWKotq0fsHMWkO6HqsaQYyvU1
         7/E0Bks3cvngtQkuw4U1dWqyhHOpcnDjS1/HI9iN0jX3wsk9pV1h+nLFhRjNfVT9CJE/
         zEUPZpHzV49XtvLlxspIwNbTa+/KnL66QDZgo=
Date: Wed, 1 Dec 2010 09:14:04 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: xpad - fix memory leak
Message-ID: <20101201171404.GB11196@core.coreip.homeip.net>
References: <1291215874-5625-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291215874-5625-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 12:04:33AM +0900, Namhyung Kim wrote:
> xpad->bdata was dynamically allocated but never freed. Since it is
> used for xpad->bulk_out->transfer_buffer, set URB_FREE_BUFFER flag
> in order to get freed when usb_free_urb() called.
> 

This is also already fixed in my tree (next branch, slated for 2.6.38).

Thanks.

-- 
Dmitry
