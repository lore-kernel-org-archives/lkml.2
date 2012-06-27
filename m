Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab2F0Pcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:32:51 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37956 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2F0Pcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:32:50 -0400
Date: Wed, 27 Jun 2012 17:32:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 06/23] perf: Add perf_output_skip function to skip bytes
 in sample
Message-ID: <20120627153229.GK20638@somewhere.redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
 <1340120894-9465-7-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340120894-9465-7-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 05:47:57PM +0200, Jiri Olsa wrote:
> Introducing perf_output_skip function to be able to skip
> data within the perf ring buffer.
> 
> When writing data into perf ring buffer we first reserve needed
> place in ring buffer and then copy the actual data.
> 
> There's a possibility we won't be able to fill all the reserved
> size with data, so we need a way to skip the remaining bytes.
> 
> This is going to be usefull when storing the user stack dump,
> where we might end up with less data than we originally requested.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
