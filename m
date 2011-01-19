Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1ASUpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 15:45:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab1ASUpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:45:12 -0500
Subject: Re: [PATCH] Avoid having to provide a fake/invalid fd and path when
 flushing marks
From: Eric Paris <eparis@redhat.com>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Date: Wed, 19 Jan 2011 15:45:04 -0500
In-Reply-To: <201101121213.58639.tvrtko.ursulin@sophos.com>
References: <201101121213.58639.tvrtko.ursulin@sophos.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1295469904.21577.35.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 12:13 +0000, Tvrtko Ursulin wrote:
> (Patch also attached in case our outgoing mail servers decide
> to munge tabs again.)
> 
> Currently for a group to flush marks it has set it needs to
> provide a fake or invalid (but resolvable) file descriptor
> and path when calling fanotify_mark. This patch pulls the
> flush handling a bit up so file descriptor and path are
> completely ignored when flushing.
> 
> Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>

Inline patch had spaces instead of tabs.  Your attached patch worked and
I committed it.  Thanks and sorry to be soooo slow!

-Eric

