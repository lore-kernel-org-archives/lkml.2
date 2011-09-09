Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343Ab1IIQEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 12:04:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759080Ab1IIQEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 12:04:05 -0400
Date: Fri, 9 Sep 2011 18:00:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Why I want PTRACE_O_TRACESTOP option
Message-ID: <20110909160048.GA23271@redhat.com>
References: <1315500802.18043.45.camel@dhcp-25-63.brq.redhat.com> <20110909001853.GA29319@htj.dyndns.org> <201109090745.35040.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109090745.35040.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09, Denys Vlasenko wrote:
>
> How about changing PTRACE_EVENT_STOP value to, say, 255 then,
> in order to move it away from (option,event) area?

Probably makes sense.

Oleg.

