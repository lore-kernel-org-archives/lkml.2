Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab2AYOZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 09:25:37 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50633 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2AYOZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 09:25:36 -0500
Message-ID: <4F2010D9.5040900@gmail.com>
Date: Wed, 25 Jan 2012 15:25:29 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120106 Thunderbird/10.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jiri Slaby <jslaby@suse.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] PM: cannot hibernate -- BUG at kernel/workqueue.c:3659
References: <4F1EC8D5.5040102@suse.cz> <201201250002.37916.rjw@sisk.pl> <4F1F4717.2090704@gmail.com> <201201250110.44360.rjw@sisk.pl>
In-Reply-To: <201201250110.44360.rjw@sisk.pl>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2012 01:10 AM, Rafael J. Wysocki wrote:
> On Wednesday, January 25, 2012, Jiri Slaby wrote:
>> Yeah, 100%. Just try it with a small enough swap.
> 
> Ah, thanks, so that's an error code path problem and most likely in the Linus'
> tree.

Just to emphasize what I wrote earlier. I would apprectiate this fixed
in 3.2 stable too.

-- 
js
