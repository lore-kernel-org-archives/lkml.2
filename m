Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab2DICCj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:02:39 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:50762 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab2DICCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:02:38 -0400
Message-ID: <4F824342.9020404@gmail.com>
Date: Sun, 08 Apr 2012 20:02:42 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf annotate browser: Initial support for navigating
 jump instructions
References: <1333832049-2399-1-git-send-email-acme@infradead.org> <1333832049-2399-7-git-send-email-acme@infradead.org>
In-Reply-To: <1333832049-2399-7-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/7/12 2:54 PM, Arnaldo Carvalho de Melo wrote:
> +	s = strchr(s, '+');
> +	if (s++ == NULL) {
> +		ui_helpline__puts("Invallid jump instruction.");

s/Invallid/Invalid/

> +		return true;
> +	}
> +
> +	offset = strtoll(s, NULL, 16);
> +	line = annotate_browser__find_offset(browser, offset,&idx);
> +	if (line == NULL) {
> +		ui_helpline__puts("Invallid jump offset");

ditto

David
