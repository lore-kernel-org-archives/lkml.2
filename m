Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab1JIJWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 05:22:30 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46180 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab1JIJW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 05:22:28 -0400
MIME-Version: 1.0
In-Reply-To: <201110062045.48689.rjw@sisk.pl>
References: <1317342456.1959.6.camel@shrek.rexursive.com>
	<3169978091.1002283638@rexursive.com>
	<201110062037.14322.rjw@sisk.pl>
	<201110062045.48689.rjw@sisk.pl>
Date: Sun, 9 Oct 2011 12:22:28 +0300
X-Google-Sender-Auth: b1ExCI7abkpRc5YbHRolCrmRDUA
Message-ID: <CAOJsxLE7uRFv6FXsz+czLO3+VjDtT-QgHVRZEpZwBJJF0B3ahw@mail.gmail.com>
Subject: Re: [PATCH v8]: Improve performance of LZO/plain hibernation
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bojan Smojver <bojan@rexursive.com>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 9:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> The panic happens during late resume, when trying to switch to the hibernated
> kernel.

Is there some way to autotest hibernation? I could try to reproduce
the issue but I'm certainly not going to hibernate/resume by hand...
:-)

                        Pekka
