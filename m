Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab2GQTO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:14:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58952 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab2GQTOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:14:23 -0400
Date: Tue, 17 Jul 2012 14:14:18 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: Willy Tarreau <w@1wt.eu>, stable@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] 3.0-stable: Fix for leapsecond deadlock &
 hrtimer/futex issue
Message-ID: <20120717191418.GF14609@burratino>
References: <1342546438-17534-1-git-send-email-johnstul@us.ibm.com>
 <20120717175741.GA3665@1wt.eu>
 <5005ABC2.8050006@us.ibm.com>
 <5005AD06.8080403@us.ibm.com>
 <20120717182601.GB14609@burratino>
 <5005B737.1030203@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5005B737.1030203@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz wrote:
> On 07/17/2012 11:26 AM, Jonathan Nieder wrote:

>> Would it be possible to put them in the kernel tree somewhere, for
>> example under tools/testing/?
>
> Huh.  I guess its possible.  However I'd like to avoid starting
> yet-another-testing-framework.

Too late: http://thread.gmane.org/gmane.linux.kernel/1223571/focus=1226221

:)
Jonathan
