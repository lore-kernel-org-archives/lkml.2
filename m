Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab2IMEpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 00:45:23 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61376 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2IMEpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 00:45:21 -0400
Date: Wed, 12 Sep 2012 21:45:15 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, Ingo Molnar <mingo@kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 2/3] perf: require exclude_guest to use PEBS - kernel
 side enforcement
Message-ID: <20120913044514.GG10019@ghostprotocols.net>
References: <1347462990-29481-1-git-send-email-dsahern@gmail.com>
 <1347462990-29481-3-git-send-email-dsahern@gmail.com>
 <87392mabqn.fsf@sejong.aot.lge.com>
 <50516220.7060507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50516220.7060507@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 12, 2012 at 10:33:36PM -0600, David Ahern escreveu:
> On 9/12/12 8:38 PM, Namhyung Kim wrote:
> >I see a whitespace problem here. :)
> 
> grr.... an extra freaking tab.

As people say down here, it happens, even in the best families... :-P

- Arnaldo

$ shutdown now tho
