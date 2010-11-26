Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab0KZKzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:55:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:41437 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab0KZKzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:55:54 -0500
Message-ID: <4CEF9225.9030109@kernel.org>
Date: Fri, 26 Nov 2010 11:55:33 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: roland@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        pavel@ucw.cz
Subject: Re: [PATCHSET RFC] ptrace,signal: sane interaction between ptrace
 and job control signals
References: <1290768569-16224-1-git-send-email-tj@kernel.org>
In-Reply-To: <1290768569-16224-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 10:55:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, again.

Ah, crap, I missed a comma between Rafael's and Pavel's email
addresses.  Sorry about that.  Rafael, Pavel, the thread can be read
from the following URL.  Probably only patch 02 and 03 are of interest
to you guys.

  http://thread.gmane.org/gmane.linux.kernel/1068420

Thanks.

-- 
tejun
