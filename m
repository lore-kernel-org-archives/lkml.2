Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab3ABJ0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 04:26:05 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16678 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab3ABJ0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 04:26:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 02 Jan 2013 01:25:48 -0800
Message-ID: <50E3FE54.6040304@nvidia.com>
Date: Wed, 2 Jan 2013 11:31:00 +0200
From: =?ISO-8859-15?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dev@lynxeye.de" <dev@lynxeye.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 3/8] gpu: host1x: Add channel support
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com>  <1356089964-5265-4-git-send-email-tbergstrom@nvidia.com> <1356149848.5896.124.camel@gandalf.local.home>
In-Reply-To: <1356149848.5896.124.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.12.2012 06:17, Steven Rostedt wrote:
> On Fri, 2012-12-21 at 13:39 +0200, Terje Bergstrom wrote:
>> +TRACE_EVENT(host1x_cdma_begin,
>> +	TP_PROTO(const char *name),
>> +
>> +	TP_ARGS(name),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(const char *, name)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->name = name;
>> +	),
>> +
>> +	TP_printk("name=%s",
>> +		__entry->name)
>> +);
>> +
>> +TRACE_EVENT(host1x_cdma_end,
>> +	TP_PROTO(const char *name),
>> +
>> +	TP_ARGS(name),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(const char *, name)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->name = name;
>> +	),
>> +
>> +	TP_printk("name=%s",
>> +		__entry->name)
>> +);
> 
> The above two should be combined into a DECLARE_EVENT_CLASS() and
> DEFINE_EVENT()s. Saves text and data space that way.

Will do.

(...)
> If you can combine any of these others into DECLARE_EVENT_CLASS() and
> DEFINE_EVENT()s, please do.

I didn't find others with same parameters.

Thanks!

Terje
