Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab1KOGWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 01:22:01 -0500
Received: from caiajhbdcbhh.dreamhost.com ([208.97.132.177]:43339 "EHLO
	homiemail-a37.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751993Ab1KOGWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 01:22:00 -0500
X-Greylist: delayed 7488 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Nov 2011 01:22:00 EST
DomainKey-Signature: a=rsa-sha1; c=nofws; d=jidanni.org; h=from:to:cc:subject
	:references:date:message-id:mime-version:content-type; q=dns; s=
	jidanni.org; b=m6VLI1Qqg3SfccKd0dBUM1y3rHaMH3MLo+NVoRICboNSTfz5e
	bIE9QaUs2M7jpGXXfqjC+EtiW7gtxZKt9QLOWZKKwdUivprnbZYvFV54EKXTYy8t
	a/+Fy2VIskI8j3YiyenyLHh8imYDVI2ktqhkYhaoWIQ2blKc0jq/532NCk=
From: jidanni@jidanni.org
To: blp@cs.stanford.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: Documentation/input/input.txt.gz has a bug
References: <87y5vihst7.fsf@blp.benpfaff.org>
Date: Tue, 15 Nov 2011 14:21:56 +0800
Message-ID: <87ipml52ij.fsf@jidanni.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "BP" == Ben Pfaff <blp@cs.stanford.edu> writes:
BP>     $ ls -l /dev/input/mouse0
BP>     crw------- 1 root root 13, 32 Nov 12 09:14 /dev/input/mouse0
Yes, but say there what your are trying to say, or else all we know is
$ cat /dev/input/mouse0 (c, 13, 32)
bash: syntax error near unexpected token `('
