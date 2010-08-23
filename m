Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab0HWNIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:08:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab0HWNIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:08:04 -0400
Date: Mon, 23 Aug 2010 09:07:48 -0400
From: Don Zickus <dzickus@redhat.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] lockup_detector: remove unnecessary panic_notifier
Message-ID: <20100823130748.GL4879@redhat.com>
References: <1282383827-12064-1-git-send-email-akinobu.mita@gmail.com>
 <1282383827-12064-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282383827-12064-2-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 06:43:47PM +0900, Akinobu Mita wrote:
> The panic notifer in lockup_detector just set did_panic to 1.
> But did_panic is not used anywhere so we can just remove it.

Thanks.

Acked-by: Don Zickus <dzickus@redhat.com>
