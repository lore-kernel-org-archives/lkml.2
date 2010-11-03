Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0KCDAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 23:00:01 -0400
Received: from kroah.org ([198.145.64.141]:46159 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab0KCC76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 22:59:58 -0400
Date: Tue, 2 Nov 2010 19:34:22 -0700
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: simon.kagstrom@netinsight.net, davem@davemloft.net, adurbin@google.com,
        akpm@linux-foundation.org, chavey@google.com,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v1 00/12] netoops support
Message-ID: <20101103023422.GB5782@kroah.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 06:29:25PM -0700, Mike Waychison wrote:
> This patchset applies to v2.6.36.
> 
> The following series implements support for 'netoops', a simple driver that
> will deliver kmsg logs together with machine specifics over the network.

We already have the ability to send oopses over the network today,
through the network consolst stuff. What does this patch set do that is
different from our existing stuff that warrants such a big change?

curious,

greg k-h
