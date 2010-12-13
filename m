Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443Ab0LMROP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:14:15 -0500
Received: from canuck.infradead.org ([134.117.69.58]:38729 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab0LMROO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:14:14 -0500
Subject: Re: [PATCH 1/2] perf tools: Add reference timestamp to perf header
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Ahern" <daahern@cisco.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1292260289.6803.297.camel@twins>
References: <1291773285-16254-1-git-send-email-daahern@cisco.com>
	 <1291773285-16254-2-git-send-email-daahern@cisco.com>
	 <20101212201613.GA1784@nowhere> <4D06301C.2090309@cisco.com>
	 <20101213155451.GA1691@nowhere> <20101213164854.GL5407@ghostprotocols.net>
	 <20101213170923.GB1691@nowhere>  <1292260289.6803.297.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Dec 2010 18:13:39 +0100
Message-ID: <1292260419.6803.300.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 18:11 +0100, Peter Zijlstra wrote:
> 
> Preferably, yes, but I don't see why we can't break the data file format
> if we've got good reasons to. 

I mean, we pretty much _have_ to break data file format when we want to
do splice() support.
