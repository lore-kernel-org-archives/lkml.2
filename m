Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077Ab2HAEEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 00:04:34 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42038 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737Ab2HAEEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 00:04:33 -0400
MIME-Version: 1.0
In-Reply-To: <1343391834-10851-1-git-send-email-jolsa@redhat.com>
References: <1343391834-10851-1-git-send-email-jolsa@redhat.com>
Date: Wed, 1 Aug 2012 06:04:31 +0200
Message-ID: <CABPqkBRRn4f00qCr+p4fh3L7SXqOBHi3CB4TJbjzSxexWRmYRw@mail.gmail.com>
Subject: Re: [PATCHv8 00/13] perf: Add backtrace post dwarf unwind
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 2:23 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> hi,
> patches available also as tarball in here:
> http://people.redhat.com/~jolsa/perf_post_unwind_v8.tar.bz2
>
> v8 changes:
>    - patch 2 - added dump registers ABI specification as suggested
>                by Stephane
>    - v7 patches 9,10,16,17 already in
>
Patches 4, 7 do not apply cleanly for me on tip-master @ commit 2a7d7ce
when I use the tarball version of the patchset.
