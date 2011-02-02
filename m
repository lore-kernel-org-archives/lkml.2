Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab1BBNxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 08:53:42 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38622 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab1BBNxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 08:53:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P2zBX3WSPAICPC7P5dUQHfkdR8o7moxWgrl6GB8TtUc49amPd5jdI+h3y9NMX83JXc
         vrKSSfLrWq0PQB+FN4nONlZTofJoaKej1Wf8sTOJQlsj9/qlcelHompahcKjAVNFgUSk
         1zrtE3lZwNzLy9ep+IpYXYa65tQYZRy01AVuk=
Date: Wed, 2 Feb 2011 14:53:31 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 00/28]  Rework of the PTP support series core code
Message-ID: <20110202135331.GA5275@riccoc20.at.omicron.at>
References: <20110201134320.688829863@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201134320.688829863@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 01:50:55PM -0000, Thomas Gleixner wrote:
> 
> Richard, can you please run that through your testing ? The PTP
> drivers apply on top of that.

My PTP convergence tests ran fine with the gianfar and phyter clocks.

Tested-by: Richard Cochran <richard.cochran@omicron.at>
