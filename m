Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab0I3HCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 03:02:01 -0400
Received: from mail.vyatta.com ([76.74.103.46]:57270 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab0I3HCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 03:02:00 -0400
Date: Thu, 30 Sep 2010 16:01:50 +0900
From: Stephen Hemminger <shemminger@vyatta.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kbuild@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Fix wrong source path in scripts/namespace.pl
Message-ID: <20100930160150.66cf0672@s6510>
In-Reply-To: <1285828138-5873-1-git-send-email-amwang@redhat.com>
References: <1285828138-5873-1-git-send-email-amwang@redhat.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010 14:28:55 +0800
Amerigo Wang <amwang@redhat.com> wrote:

> File::Find will do chdir automatically, so we need to get
> the absolute patch with $File::Find::dir.
> 
> Reported-by: Stephen Hemminger <shemminger@vyatta.com>
> Signed-off-by: Amerigo Wang <amwang@redhat.com>

Works for me.
