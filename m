Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab0ITVZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 17:25:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48033 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab0ITVZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 17:25:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=QDR5ieKAoUWLiR1bYN0p345cHQn6/4CqGpePEqvQEi31/dpWPR1iTwydrXKt0iPav4
         pB15xo9S/y/EPEHjYdoNm4rpqRzUvukaAekJ43vwwY/wDKKsqbeh2g3dzbhH6/Kjj4M6
         tRGPDPrcA2303PcNdyAwI08YTVW7FOkBmsFrc=
Message-ID: <4C97D197.9070703@gmail.com>
Date: Mon, 20 Sep 2010 23:26:47 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        "Jean Delvare \(PC drivers\, core\)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Steve Wise <swise@chelsio.com>, Neil Brown <neilb@suse.de>,
        Paul Mackerras <paulus@samba.org>, linux-i2c@vger.kernel.org,
        linux-rdma@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: idr_get_new_exact ?
References: <AANLkTi=ZLupVyFR0e2v-TLpeNWdw1bVMZUAhgyxLJ7OV@mail.gmail.com> <adaiq20f90h.fsf@cisco.com>
In-Reply-To: <adaiq20f90h.fsf@cisco.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/20/2010 10:35 PM, Roland Dreier wrote:
> Looks fine to me as an improvement over the status quo, but I wonder how
> many of these places could use the radix_tree stuff instead?  If you're
> not using the ability of the idr code to assign an id for you, then it
> seems the radix_tree API is a better fit.

I agree.  Wouldn't those users better off simply using radix tree?

Thanks.

-- 
tejun
