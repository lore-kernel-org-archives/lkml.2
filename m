Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab2C0OCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 10:02:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41198 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2C0OB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 10:01:59 -0400
Date: Tue, 27 Mar 2012 11:01:55 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] perf: Handle NULL dso in dso__name_len
Message-ID: <20120327140155.GE5195@infradead.org>
References: <20120325.162822.2267799792062571623.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120325.162822.2267799792062571623.davem@davemloft.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Mar 25, 2012 at 04:28:22PM -0400, David Miller escreveu:
> 
> We should use "[unknown]" in this case, in concert with the code in
> _hist_entry__dso_snprintf().
> 
> Otherwise we'll crash when recomputing the histogram column lengths in
> hists__calc_col_len().

Thanks, applied.

- Arnaldo
