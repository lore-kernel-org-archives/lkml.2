Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab1F0IL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 04:11:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41803 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab1F0ILo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 04:11:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XrT5lfA5NmNf/o0kTTMwXqNq+C7v2GH5ZbH7wHmEOf79KqID5wXqlbZ5nCYqQutKgX
         zuVhPV3rtGdU9W3n/vL9/sxqK7x1avHUN+nKPnD+1+8kk55UVJiAkxvZTfxadza90Bki
         MhmO+8fmV4+mvriLUhP0k3hVFUKwaFsoRkqbc=
Date: Mon, 27 Jun 2011 10:11:39 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: make former thread ID available via
 PTRACE_GETEVENTMSG after PTRACE_EVENT_EXEC stop (v.2)
Message-ID: <20110627081139.GY30101@htj.dyndns.org>
References: <201106262108.43011.vda.linux@googlemail.com>
 <20110626200442.GA16293@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110626200442.GA16293@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg, Denys.

On Sun, Jun 26, 2011 at 10:04:42PM +0200, Oleg Nesterov wrote:
> May be PT_TRACE_EXEC makes more sense. Note that
> ptrace_event_enabled() was recently added.

Do we want to enable this silently?  Wouldn't it be better to make it
dependent on PT_SEIZED?  Otherwise, it's something which simply might
or might not be there.

-- 
tejun
