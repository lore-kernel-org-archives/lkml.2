Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966002Ab2EPCen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 22:34:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34837 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759016Ab2EPCej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 22:34:39 -0400
Message-ID: <4FB3123A.6070707@gmail.com>
Date: Tue, 15 May 2012 20:34:34 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com
Subject: Re: [PATCH v2 3/5] perf tools: rename HEADER_TRACE_INFO to HEADER_TRACING_DATA
References: <1337081295-10303-1-git-send-email-eranian@google.com> <1337081295-10303-4-git-send-email-eranian@google.com>
In-Reply-To: <1337081295-10303-4-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/12 5:28 AM, Stephane Eranian wrote:
> To match the PERF_RECORD_HEADER_TRACING_DATA record type.
> This is the same info as the one used for pipe mode whereas
> the other one is for regular file output. This will help in
> the later patch to add meta-data infos in pipe mode.
>
> Signed-off-by: Stephane Eranian<eranian@google.com>

Reviewed-by: David Ahern <dsahern@gmail.com>

