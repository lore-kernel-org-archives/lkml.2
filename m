Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab2ITNo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:44:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43876 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab2ITNoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:44:25 -0400
Message-ID: <505B1DB5.1030304@gmail.com>
Date: Thu, 20 Sep 2012 07:44:21 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/4] perf header: Save and reuse feature information in
 header (v3)
References: <1348119407-12528-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1348119407-12528-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/12 11:36 PM, Namhyung Kim wrote:
> Hi,
>
> Currently the perf header information is used only at initial setup
> time and discarded.  If it's saved we could reuse the information for
> various purpose in the future.

When this gets settled can you update builtin-kvm too? The kvm-events 
patch too adds a perf_file_section__read_feature() function for 
extracting cpuid from the header.

David

