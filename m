Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab1KOThL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 14:37:11 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:41982 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756356Ab1KOThK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 14:37:10 -0500
Message-ID: <4EC2BEF6.7070906@xenotime.net>
Date: Tue, 15 Nov 2011 11:35:18 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: jidanni@jidanni.org
CC: linux-kernel@vger.kernel.org
Subject: Re: Documentation/input/input.txt.gz has a bug
References: <8762im2n5f.fsf@jidanni.org>
In-Reply-To: <8762im2n5f.fsf@jidanni.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2011 05:24 PM, jidanni@jidanni.org wrote:
> /usr/share/doc/linux-doc-3.0.0/Documentation/input/input.txt.gz
> Has an error at "(c, 13, 32)" or needs an explanation added:
> 
>   Doing a cat /dev/input/mouse0 (c, 13, 32) will verify that a mouse
> is also emulated, characters should appear if you move it.


  Doing a "cat /dev/input/mouse0" (char device 13,32) will verify that
a mouse is also emulated; characters should appear if you move it.

or

  Doing a
$ cat /dev/input/mouse
(which is char device 13,32) will verify that a mouse is also
emulated; characters should appear if you move it.


Do you want to submit a patch?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
