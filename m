Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637Ab2IHBO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 21:14:29 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52098 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758638Ab2IHBO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 21:14:28 -0400
Date: Fri, 7 Sep 2012 18:14:22 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: mingo@redhat.com, a.p.zijlstra@chello.nl, rostedt@goodmis.org,
        paulus@samba.org, dsahern@gmail.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v2 00/12] Porting perf to Android
Message-ID: <20120908011422.GF20401@ghostprotocols.net>
References: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Sep 08, 2012 at 03:43:12AM +0300, Irina Tirdea escreveu:
> This is version 2 for the patches to port perf to Android.
> With these patches perf compiles on latest Android tree (JellyBean).
> 
> The patches are on top of current perf/core branch of the tip tree.

Thanks, I applied 6 out of 12, will revisit each of them later with
comments after I think a about them a bit more,

- Arnaldo
