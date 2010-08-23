Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab0HWNGC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:06:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab0HWNF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:05:59 -0400
Date: Mon, 23 Aug 2010 09:05:23 -0400
From: Don Zickus <dzickus@redhat.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] lockup_detector: convert cpu notifier to return
 encapsulate errno value
Message-ID: <20100823130523.GK4879@redhat.com>
References: <1282383827-12064-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282383827-12064-1-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 06:43:46PM +0900, Akinobu Mita wrote:
> By the commit e6bde73b07edeb703d4c89c1daabc09c303de11f
> ("cpu-hotplug: return better errno on cpu hotplug failure"),
> the cpu notifier can return encapsulate errno value.
> 
> This converts the cpu notifier to return encapsulate errno value
> for lockup_detector.

Looks ok.

Acked-by: Don Zickus <dzickus@redhat.com>
