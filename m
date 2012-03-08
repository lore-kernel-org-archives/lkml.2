Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab2CHD7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 22:59:55 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:37840 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab2CHD7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 22:59:33 -0500
Message-ID: <1331179148.2191.261.camel@work-vm>
Subject: Re: [PATCH 05/11] android: ram_console: split out persistent ram
From: John Stultz <john.stultz@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>
Date: Wed, 07 Mar 2012 19:59:08 -0800
In-Reply-To: <20120308024203.GA25842@kroah.com>
References: <1331170478-30538-1-git-send-email-john.stultz@linaro.org>
	 <1331170478-30538-6-git-send-email-john.stultz@linaro.org>
	 <20120308024203.GA25842@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030803-4242-0000-0000-000000FDA479
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 18:42 -0800, Greg KH wrote:
> Because of this, sorry, I can't take the rest of these patches in this
> series.  If the 10th or 11th ones are needed, care to refresh it against
> my tree and resend it so that I can take it?

10/11 depends on the patches you didn't take, so it gets dropped as
well.

11/11 should still apply, and shouldn't need to be refreshed. 
Would you mind applying it, or do you really want it send it on its
own? 

thanks
-john


