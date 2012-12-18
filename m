Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab2LRP24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:28:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab2LRP2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:28:55 -0500
Date: Tue, 18 Dec 2012 16:28:44 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 02/14] perf test: Add group test conditions
Message-ID: <20121218152844.GJ1283@krava.brq.redhat.com>
References: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
 <1355726345-29553-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355726345-29553-3-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 03:38:53PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> As some new fields for handling groups added, check them to be sure to
> have valid values in test__group* cases.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>
