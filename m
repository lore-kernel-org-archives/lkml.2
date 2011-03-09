Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab1CIN2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 08:28:14 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52467 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab1CIN2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:28:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=KyDQ78VuGJJKB4DT44sBeZDgOysamBaOO+lGnY4KV5gtoeQkouQlwgJ9fQ0Cg65BmD
         eHYcLWn0qeN3z7aa5nYbyc9XW6ySf6T8CYm0pOOE1dqrpQsU/8dcw3SvUFNn3C6XpWy5
         XXtXuNKUYYkHr+WJ0QUCrh6iuVxaTqdP8WIA4=
From: Wang Lei <f3d27b@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Fans keep running, first found since v2.6.38-rc7
References: <4d774c85.20f98e0a.2695.73ed@mx.google.com>
	<201103091141.28396.rjw@sisk.pl>
Date: Wed, 09 Mar 2011 21:28:21 +0800
In-Reply-To: <201103091141.28396.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Wed, 9 Mar 2011 11:41:28 +0100")
Message-ID: <4d77806c.0bf98e0a.28c5.7cc5@mx.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

>
> There was only one commit in that area since 2.6.38-rc6, but it shouldn't
> affect the functionality this way.
>
> Is yout thermal management controlled by ACPI?
>
> Rafael

Thanks for your reply!

How could I know that?

-- 
Regards,
Lei
