Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab1AOAdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 19:33:46 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:38603
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751431Ab1AOAdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 19:33:45 -0500
Date: Sat, 15 Jan 2011 00:35:13 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/08] Allow ptrace from non-init user namespaces
Message-ID: <20110115003513.GC24569@mail.hallyn.com>
References: <20110111064342.GA27515@mail.hallyn.com>
 <20110111064439.GF27515@mail.hallyn.com>
 <20110114144608.GA20945@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114144608.GA20945@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Bastian Blank (bastian@waldi.eu.org):
> This mail did not show up in my inbox, even if I'm listed as receipient.
> I only got a copy via the mailinglist.

Yes, I always get errors sending to you:

<bastian@waldi.eu.org>: host mail.thinkmo.de[83.137.100.41] said: 504 5.5.2
    <mail>: Helo command rejected: need fully-qualified hostname (in reply to
    RCPT TO command)

(cc: list trimmed, hopefully this is the m-l you actually read :)
