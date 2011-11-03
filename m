Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381Ab1KCGiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 02:38:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45309 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1KCGiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 02:38:09 -0400
MIME-Version: 1.0
In-Reply-To: <201111030201.27551.rjw@sisk.pl>
References: <20111101021511.GP18855@google.com>
	<201111030120.42102.rjw@sisk.pl>
	<20111103004350.GA4417@google.com>
	<201111030201.27551.rjw@sisk.pl>
Date: Wed, 2 Nov 2011 23:38:08 -0700
X-Google-Sender-Auth: xDEdkAfQrO8OVkXD-NK8jq21kAg
Message-ID: <CAOS58YN4eQ5qfGXCjciGKvv13boSKQJso2U=x5rLw8c7vNeGWQ@mail.gmail.com>
Subject: Re: [PATCH pm] freezer: fix wait_event_freezable/__thaw_task races
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 2, 2011 at 6:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> OK, so I guess I should drop it from my linux-next branch?

Hmmm... yes, the preceding patches should be applied first and then
this one. Any problems with earlier ones?

Thank you.

-- 
tejun
