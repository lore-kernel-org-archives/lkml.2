Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215Ab0EAGcj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 02:32:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:51723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab0EAGch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 02:32:37 -0400
Message-ID: <4BDBCACA.8030505@kernel.org>
Date: Sat, 01 May 2010 08:31:38 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, graff.yang@gmail.com,
       akpm@linux-foundation.org, uclinux-dist-devel@blackfin.uclinux.org,
       sonic.adi@gmail.com, cl@linux-foundation.org, mingo@elte.hu
Subject: Re: percpu: implement nommu support
References: <1270699865-16954-1-git-send-email-tj@kernel.org> <20986.1270735576@redhat.com>
In-Reply-To: <20986.1270735576@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 01 May 2010 06:31:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 04:06 PM, David Howells wrote:
> It looks reasonable (feel free to add my Reviewed-by).  But I can't test it as
> I don't have any SMP NOMMU hardware.

Published to linux-next w/ Reviewed-by added.  Thank you.

-- 
tejun
