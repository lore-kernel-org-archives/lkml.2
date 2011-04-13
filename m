Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab1DMCic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 22:38:32 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41229 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab1DMCib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 22:38:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=efsKEn5W5edOWmNhLqGQpaO91P9ONuzBxGH2OHq0svmOwtIGmW/mmy4uu/sTM8sHKJ
         AkAOkHyNq4+tNa4nn1PltRaY7h3Jg9hUcGVgt5VJexAJHMvh+OSC/TZtWIwa2dGm/foz
         t0DoCF5lFfrpnwzCK35qEUA5M+QqfDBrraWSg=
MIME-Version: 1.0
In-Reply-To: <20110412091346.1afa945f@jbarnes-desktop>
References: <1301908379-19283-1-git-send-email-wanlong.gao@gmail.com>
	<20110412091346.1afa945f@jbarnes-desktop>
Date: Wed, 13 Apr 2011 10:37:28 +0800
Message-ID: <BANLkTikXBQ8NuoeaonsstZqnURxRzyXqBQ@mail.gmail.com>
Subject: Re: [PATCH]X86:PCI: Fix an uninitialized variable warning
From: wanlong gao <wanlong.gao@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: prarit@redhat.com, kaneshige.kenji@jp.fujitsu.com,
        seto.hidetoshi@jp.fujitsu.com, arnd@arndb.de,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        harryxiyou@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/13/11, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Mon,  4 Apr 2011 17:12:59 +0800
> wanlong.gao@gmail.com wrote:
>
>> From: Wanlong Gao <wanlong.gao@gmail.com>
>>
>> If it was preempted , and the variable aer_mask_override is
>> changed after the spin_unlock_irqrestore ,  it will write an
>> uninitialized variable by the pci_write_config_dword() function .
>
> Applied to my linux-next branch, thanks.
Thank you for your hard work to the open-source .

Best regards .
>
> --
> Jesse Barnes, Intel Open Source Technology Center
>


-- 
Best regards
Wanlong Gao
