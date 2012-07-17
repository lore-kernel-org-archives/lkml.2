Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab2GQS0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:26:09 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53983 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2GQS0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:26:06 -0400
Date: Tue, 17 Jul 2012 13:26:01 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: Willy Tarreau <w@1wt.eu>, stable@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] 3.0-stable: Fix for leapsecond deadlock &
 hrtimer/futex issue
Message-ID: <20120717182601.GB14609@burratino>
References: <1342546438-17534-1-git-send-email-johnstul@us.ibm.com>
 <20120717175741.GA3665@1wt.eu>
 <5005ABC2.8050006@us.ibm.com>
 <5005AD06.8080403@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5005AD06.8080403@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz wrote:

> Are there any other test suites that folks would recommend I look
> into for merging these (and other time related) tests?

Would it be possible to put them in the kernel tree somewhere, for
example under tools/testing/?

Thanks,
Jonathan
