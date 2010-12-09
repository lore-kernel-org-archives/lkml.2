Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab0LIJuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:50:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:34161 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab0LIJuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:50:50 -0500
Message-ID: <4D00A672.9050906@kernel.org>
Date: Thu, 09 Dec 2010 10:50:42 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
CC: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv1 000/211] unicore32 architecture support
References: <01ca01cb9783$7818c3f0$684a4bd0$@mprc.pku.edu.cn>
In-Reply-To: <01ca01cb9783$7818c3f0$684a4bd0$@mprc.pku.edu.cn>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 09:50:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/09/2010 10:28 AM, Guan Xuetao wrote:
> From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> 
> These patches add support for UniCore-32 ISA in linux kernel.
> UniCore ISA is defined and developed by Micro-Processor R&D Center of
> Peking University, and over the years, the CPUs and SoCs using UniCore ISA
> have been successfully applied in a variety of products in China.

* Patches should be split according to logical steps of changes, not
  per-file.

* Patches should be bisectable.  IOW, after applying upto any patch in
  the series, the tree should be buildable and working.

* When posting a patch series, especially one as large as 211, please
  make the mails for the actual patches replies to the head message.
  Don't post it as 212 separate messages or replies to the immediate
  previous patch.

So, in short, if you're adding a whole new arch, just post it as a
single patch or a series of several patches if it requires changes
outside of the specific arch subtree.

Thanks.

-- 
tejun
