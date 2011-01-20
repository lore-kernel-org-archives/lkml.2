Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab1ATBwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 20:52:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753369Ab1ATBwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 20:52:06 -0500
Date: Wed, 19 Jan 2011 17:51:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Feng Tang <feng.tang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "alan@linux.intel.com" <alan@linux.intel.com>
Subject: Re: [PATCH] console: prevent registered consoles from dumping old
 kernel message over again
Message-Id: <20110119175134.5a2f283f.akpm@linux-foundation.org>
In-Reply-To: <20110120094458.144708e0@feng-i7>
References: <1294814926-1460-1-git-send-email-feng.tang@intel.com>
	<20110119161135.aee848bb.akpm@linux-foundation.org>
	<20110120094458.144708e0@feng-i7>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011 09:44:58 +0800
Feng Tang <feng.tang@intel.com> wrote:

> > How's about something like this?
> 
> Yes, it makes sense, I should add some check. And this new
> "exclusive_console" should be better as its name shows what it is for.

Is it racy, or does console_sem coverage save us?

Anyway.  If you think that the exclusive_console approach is suitable,
please send a tested patch back at me sometime?

