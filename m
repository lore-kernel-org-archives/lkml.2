Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab2ALBlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 20:41:08 -0500
Received: from lo.gmane.org ([80.91.229.12]:41127 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab2ALBlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 20:41:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH RESEND 9/9] block, trace: implement ioblame - IO tracer
 with origin tracking
Date: Thu, 12 Jan 2012 10:40:44 +0900
Message-ID: <4F0E3A1C.5000105@gmail.com>
References: <1326220106-5765-1-git-send-email-tj@kernel.org> <1326220106-5765-10-git-send-email-tj@kernel.org> <20120111013212.GA6843@dhcp-172-17-108-109.mtv.corp.google.com> <4F0D291A.8030205@lge.com> <20120111170635.GE26832@google.com> <4F0E31D9.3080306@lge.com> <CAOS58YOMKvb5Gj5CeP6t11NHwSdbZWUJ=uC6aRxd6CxpNrwskg@mail.gmail.com> <4F0E38E6.4070606@lge.com> <CAOS58YNSn079KusXuEYf7agyWgMyaZahp7+4rWRFQz_G3k8CjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: Namhyung Kim <namhyung@gmail.com>, axboe@kernel.dk, mingo@redhat.com,
        rostedt@goodmis.org, fweisbec@gmail.com, teravest@google.com,
        slavapestov@google.com, ctalbott@google.com, dhsharp@google.com,
        linux-kernel@vger.kernel.org, winget@google.com,
        Chanho Park <chanho61.park@samsung.com>
X-Gmane-NNTP-Posting-Host: 121.50.20.41
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
In-Reply-To: <CAOS58YNSn079KusXuEYf7agyWgMyaZahp7+4rWRFQz_G3k8CjQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-01-12 10:37 AM, Tejun Heo wrote:
> Hello,
>
> On Wed, Jan 11, 2012 at 5:35 PM, Namhyung Kim<namhyung.kim@lge.com>  wrote:
>> Why do we need to trigger the TP for existing ones as we keep each entry at
>> its creation? Maybe I'm missing something?
>
> If a userland program starts to watch the TP after some intents are
> created, how is it gonna find out the existing ones?
>

Hi,

OK, but that can be controlled from userspace, I guess? Do we have to 
care about that?

Thanks,
Namhyung Kim

