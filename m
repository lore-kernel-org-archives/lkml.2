Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0KAUlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:41:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37694 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab0KAUln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:41:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=C9eEMCIPS0OvPm/ik53/qJDpxyW4K2LwdnMOmT/eXeiPg+HNu18lSAGqnQG2bTD3op
         8T+KhKsbQxbvt8275Qa15NWrJMQC5VW15rXrDgZJ8n9KJryOlC2DZKERsX4cLr8pW9DC
         Rfy5Oe4QU7mfq6AK/djMGi9lBOW8cmCKkpZEs=
From: Ben Gamari <bgamari.foss@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Add Kconfig option for default swappiness
In-Reply-To: <alpine.LNX.2.00.1011012108360.12889@swampdragon.chaosbits.net>
References: <1288548508-22070-1-git-send-email-bgamari.foss@gmail.com> <alpine.LNX.2.00.1011012108360.12889@swampdragon.chaosbits.net>
User-Agent: Notmuch/0.3.1-158-g04cd99c (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Mon, 01 Nov 2010 16:41:35 -0400
Message-ID: <87wrowrd34.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010 21:09:58 +0100 (CET), Jesper Juhl <jj@chaosbits.net> wrote:
> Perhaps this help text should mention the fact that swapiness setting can 
> be changed at runtime (regardless of the set default) by writing to 
> /proc/sys/vm/swappiness ???
> 
This definitely wouldn't hurt. I'll respin with updated help text.

- Ben
