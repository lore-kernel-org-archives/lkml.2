Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab2EOEaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 00:30:03 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58798 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab2EOEaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 00:30:00 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-f8-4fb1dbc545c9
From: Namhyung Kim <namhyung.kim@lge.com>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf-record: Create events initially disabled -- again
References: <1336968088-11531-1-git-send-email-dsahern@gmail.com>
	<87sjf31a8c.fsf@sejong.aot.lge.com> <4FB1041C.1050903@gmail.com>
	<4FB114CE.10904@gmail.com> <20120514145416.GB4254@infradead.org>
	<4FB1B6EA.1060206@gmail.com> <4FB1CD47.7090202@gmail.com>
Date: Tue, 15 May 2012 13:28:21 +0900
In-Reply-To: <4FB1CD47.7090202@gmail.com> (David Ahern's message of "Mon, 14
	May 2012 21:28:07 -0600")
Message-ID: <878vgu1316.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 14 May 2012 21:28:07 -0600, David Ahern wrote:
> I think I'm getting dizzy, and I knew I tested the whole 'perf-stat
> -g' thing. It works *fine* on a Westmere box (E5620); the above
> comments apply to a VM on a Nehalem server (E5540). (host is running
> 3.4.0-rc7 kernel and -cpu host argument for qemu-kvm.)
>
> Namhyung/Arnaldo: What processor are you using?
>

$ grep "model name" /proc/cpuinfo | sort -u
model name	: Intel(R) Core(TM) i7-3930K CPU @ 3.20GHz

Thanks,
Namhyung
