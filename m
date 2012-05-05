Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759028Ab2EEDSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 23:18:36 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:44195 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab2EEDSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 23:18:35 -0400
Message-ID: <4FA49B49.9000203@gmail.com>
Date: Sat, 05 May 2012 11:15:21 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Pierre Carrier <pierre@spotify.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Rob Landley <rob@landley.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] procfs: expose umask in stat and status
References: <1336186227-1941-1-git-send-email-pierre@spotify.com>
In-Reply-To: <1336186227-1941-1-git-send-email-pierre@spotify.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2012 10:50 AM, Pierre Carrier wrote:
> A new stat field uses decimal, contains umask or -ENOENT if !task->fs.

How is it useful to display numeric -ENOENT in a /proc file?

> A new status line is displayed if task->fs, and uses octal.

So sometimes "Umask:" is displayed, sometimes not...
