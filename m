Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab2C0N73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 09:59:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47938 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab2C0N72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 09:59:28 -0400
Date: Tue, 27 Mar 2012 10:59:25 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Do not include libgen.h
Message-ID: <20120327135925.GD5195@infradead.org>
References: <20120327.000301.1122788061724345175.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120327.000301.1122788061724345175.davem@davemloft.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 27, 2012 at 12:03:01AM -0400, David Miller escreveu:
> 
> That causes us to end up using the XPG version of basename which can
> modify it's argument.

Thanks, applied.

- Arnaldo
