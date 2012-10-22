Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab2JVA60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 20:58:26 -0400
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:57719 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab2JVA6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 20:58:25 -0400
Message-ID: <50849979.5080505@ce.jp.nec.com>
Date: Mon, 22 Oct 2012 09:55:21 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix use-after-free of q->root_blkg and q->root_rl.blkg
References: <50750367.2070508@ce.jp.nec.com> <20121010155929.GA18733@redhat.com> <50762182.5090806@ce.jp.nec.com> <20121016232040.GH16166@google.com> <507DF58E.8060804@ce.jp.nec.com> <20121017134704.GB31663@redhat.com> <507F6FE2.3030303@ce.jp.nec.com> <20121018133149.GA18147@redhat.com> <20121018212053.GK13370@google.com> <20121019145350.GD27052@redhat.com>
In-Reply-To: <20121019145350.GD27052@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/12 23:53, Vivek Goyal wrote:
> On Thu, Oct 18, 2012 at 02:20:53PM -0700, Tejun Heo wrote:
>> Hey, Vivek.
>>
>> On Thu, Oct 18, 2012 at 09:31:49AM -0400, Vivek Goyal wrote:
>>> Tejun, for the sake of readability, are you fine with keeping the original
>>> check and original patch which I had acked.
>>
>> Can you please send another patch to change that?  It really isn't a
>> related change and I don't wanna mix the two.
> 
> Sure. Jun'ichi, would you like to send that cleanup line in a separate patch? 

OK. I will send that patch.

-- 
Jun'ichi Nomura, NEC Corporation

