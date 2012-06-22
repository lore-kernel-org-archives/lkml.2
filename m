Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762302Ab2FVQYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:24:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55457 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab2FVQYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:24:16 -0400
Message-ID: <4FE49C2D.3000509@gmail.com>
Date: Fri, 22 Jun 2012 10:24:13 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC/PATCHSET 0/8] perf tools: Minimal build without libelf dependency
 (v2)
References: <1340343462-15556-1-git-send-email-namhyung@kernel.org> <1340358478.18025.51.camel@twins> <1340377510.1478.10.camel@leonhard> <4FE48CCA.2050506@gmail.com> <1340379000.1478.34.camel@leonhard> <4FE490C9.1020903@gmail.com> <20120622161449.GL17747@infradead.org>
In-Reply-To: <20120622161449.GL17747@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/22/12 10:14 AM, Arnaldo Carvalho de Melo wrote:
> I think at least the .dymsym symbol table is present in DSOs, aka
> libraries, otherwise how will they dynamicly link?
>
> - Arnaldo
>

yes. I meant debug information wise - everything is stripped during 
packaging phase, so onbox analysis is severely limited in address to 
symbol resolutions.

David

