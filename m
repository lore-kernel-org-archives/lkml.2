Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1CEKev (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 05:34:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36247 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab1CEKet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 05:34:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fm6yYBebl06kPKVSd9uHbMrNyL/WZkE7ad4KryaeC6awhI+qHb8pZHA13EOk74QPQG
         4FkFKhAqB5nH8kB8VAWfohohgges64eSN8eCrNxfzGn2YaCrK257sZSU/YMrGJ8dJtkv
         YxsF22vuOCZFSgs15Amy3V4NvcjwVyqnIpSLA=
Date: Sat, 5 Mar 2011 13:34:44 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] power: disable hibernation if module loading is
 disabled
Message-ID: <20110305103444.GA26773@albatros>
References: <1299255084-4390-1-git-send-email-segoon@openwall.com>
 <201103042221.02852.rjw@sisk.pl>
 <20110304214630.GA29883@albatros>
 <201103042330.25079.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103042330.25079.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 23:30 +0100, Rafael J. Wysocki wrote:
> modules_disabled surely is not the right interface to disable hibernation
> and I don't really think there's a bug because it doesn't work as you'd like
> it to.  In fact, there would be a bug if it did work that way.

What do you mean here?  Do you agree that you may read kernel image,
slightly change it (including e.g. possible checksums, I didn't bother
to check how much one should change), and write it back?

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
