Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab2GQRtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:49:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63496 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033Ab2GQRtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:49:40 -0400
Date: Tue, 17 Jul 2012 12:49:35 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 04/11] 3.0.x: time: Move common updates to a function
Message-ID: <20120717174935.GJ3071@burratino>
References: <1342546438-17534-1-git-send-email-johnstul@us.ibm.com>
 <1342546438-17534-5-git-send-email-johnstul@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342546438-17534-5-git-send-email-johnstul@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz wrote:

> From: Thomas Gleixner <tglx@linutronix.de>
>
> This is a backport of cc06268c6a87db156af2daed6e96a936b955cc82
>
> While not a bugfix itself, it allows following fixes to backport
> in a more straightforward manner.

Nicely done; thank you.
