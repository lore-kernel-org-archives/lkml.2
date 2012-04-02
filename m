Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab2DBQHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 12:07:14 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14584 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2DBQHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 12:07:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6667"; a="178077765"
Message-ID: <4F79CEAF.9050606@codeaurora.org>
Date: Mon, 02 Apr 2012 09:07:11 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: mmarek@suse.cz, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Yang Bai <hamo.by@gmail.com>
Subject: Re: [PATCH 1/1] scripts: fix cscope breakage
References: <1333365517-18936-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1333365517-18936-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/12 04:18, Jiri Slaby wrote:
> Commit 66979224c0d2 (scripts: refactor remove structure forward
> declarations) introduced a breakage in tags.sh for others than tags.
> So make cscope now fails with:
> sed: can't read cscope: No such file or directory
>

Thanks. It was already reported/fixed and a pull request has been sent.

https://lkml.org/lkml/2012/4/1/12

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

