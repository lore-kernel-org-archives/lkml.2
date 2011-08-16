Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab1HPTlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:41:05 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:36385 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752266Ab1HPTlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:41:01 -0400
Subject: Re: [PATCH 00/41] signal: Use set_current_blocked()
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110811160358.GA7989@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
	 <20110811160358.GA7989@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Aug 2011 20:40:59 +0100
Message-ID: <1313523659.3436.184.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 18:03 +0200, Oleg Nesterov wrote:
> 
> I'll try to read this carefully on weekend though. I do not expect I'll
> find any problem, just may be a couple of nits about the changelogs.
> Say, 41/41... doesn't hurt, but in fact the current code is fine as is.

Thanks for the review Oleg! Did you want me to send just the updated
versions of patches or the entire series again? It would seem over the
top to send the entire series.

Also, are you going to pull these patches into your tree and send them
to Linus or would it be better to route them through -mm?

-- 
Matt Fleming, Intel Open Source Technology Center

