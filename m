Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab2FROiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:38:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62676 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab2FROiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:38:23 -0400
Message-ID: <4FDF3D5C.1030209@gmail.com>
Date: Mon, 18 Jun 2012 08:38:20 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: rostedt@goodmis.org, acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        weisbec@gmail.com, namhyung.kim@lge.com, mingo@kernel.org,
        peterz@infradead.org
Subject: Re: [RFC PATCH 0/2] libtraceevent/perf: Add support for trace-cmd
 plugins
References: <1339695333-64591-1-git-send-email-dsahern@gmail.com> <87lijlhv9v.fsf@sejong.aot.lge.com>
In-Reply-To: <87lijlhv9v.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung:

On 6/18/12 2:35 AM, Namhyung Kim wrote:
> And for this particular case in patch 2/2, it seems that format of the
> kvm_emulate_insn event is broken already and should be fixed anyway.
> Further improvement in this area can be addressed in perf kvm or other
> users if needed.

kvm tracepoints are fine; perf just doesn't handle their (advanced) 
formatting.

Note that I am referring to kvm:* tracepoints, not perf-kvm which has 
its own issues that need to be fixed.

David
