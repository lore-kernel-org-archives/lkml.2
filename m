Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab0L1PCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 10:02:32 -0500
Received: from lo.gmane.org ([80.91.229.12]:58745 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab0L1PCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 10:02:30 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: blp@cs.stanford.edu (Ben Pfaff)
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Tue, 28 Dec 2010 07:02:06 -0800
Message-ID: <87wrmu54b5.fsf@benpfaff.org>
References: <201012280953.46149.kernel@kolivas.org>
	<20101228025343.GD10149@thunk.org> <4D19BEF1.9010708@shiftmail.org>
	<20101228143255.GI10149@thunk.org>
Reply-To: blp@cs.stanford.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 76.14.48.202
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Cancel-Lock: sha1:5qAzof5nAatqkxxEQdq8iTzHDic=
Cc: linux-usb@vger.kernel.org, linux-ext4@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted Ts'o <tytso@mit.edu> writes:

> On Tue, Dec 28, 2010 at 11:41:53AM +0100, torn5 wrote:
>> 
>> This is going to be a faq...
>> I suppose the datetime is encoded (what format is that?) in that
>> long number after "at".
>
> Number of seconds since January 1st, 1970 midnight GMT.  (Standard
> Unix-time format).  It's hard for the kernel to decode it since it
> doesn't know what time-zone you are in, or what your local legislature
> has done vis-a-vis arbitrary and cabritious adjustments to the
> start/stop date of daylight savings time, etc.
>
> It's easy enough to decode it using perl:
>
>    perl -e '$t = localtime(1289053677); print "$t\n"'

The "date" program can decode these values too:
        date -d @1289053677
-- 
Ben Pfaff 
http://benpfaff.org

