Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361Ab1EBOXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 10:23:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53369 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759183Ab1EBOXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 10:23:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GSCE/huQ3gLRMdFK002YOEtqpAGG0+8wmt+3QbjtRpdG/7MuOrq0VVGstglRkR88YP
         iwhF+9A46iQjK6I0zlajcTA2k8cyl+s6FSbIedEsmq5KNBe3um2u3PRnUFZbhILm04Ri
         z0C+RxMkKKZKH7Odm+k7TS/BJ8HoOsl8P94TA=
Message-ID: <4DBEBE72.3040702@gmail.com>
Date: Mon, 02 May 2011 18:23:46 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] x86, x2apic: minimize IPI register writes using cluster
 groups v4
References: <20110502113445.751391656@openvz.org> <20110502114024.222582172@openvz.org> <20110502132232.GA3873@elte.hu> <4DBEB96A.8000309@openvz.org>
In-Reply-To: <4DBEB96A.8000309@openvz.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2011 06:02 PM, Cyrill Gorcunov wrote:
...
> 
>   Ingo, the idea was to merge probe_x.c completely, and put all this not into init()
> but rather into apic->probe() or something like that. I don't have a clear picture
> in mind yet what the best way would be, so instead of fast designed method I thought
> to leave it opencoded with fixme note.
> 
>   So lets wait until Suresh post the benchmark and I will make apic->init() meanwhile.
> 

  Ingo, would it be fine to make apic->init() either _before_ this series or on
top of them (because if I introduce it inside this particular patch it would contain
some unrelated code snippets such as .init = NULL for all apics declaration).

-- 
Thanks,
  Cyrill
