Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab1HPRXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:23:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab1HPRXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:23:39 -0400
Date: Tue, 16 Aug 2011 19:20:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 12/41] microblaze: Don't reimplement force_sigsegv()
Message-ID: <20110816172049.GD29190@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-13-git-send-email-matt@console-pimps.org> <20110816172010.GC29190@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110816172010.GC29190@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16, Oleg Nesterov wrote:
>
> This and the next patch seem to have the same problems with the
> changelogs as 18 and 19.
>
> 13-14 looks correct to me...

I meant 14-15, sorry for noise

Oleg.

