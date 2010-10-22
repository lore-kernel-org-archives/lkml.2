Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab0JVIAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:00:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:49827 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873Ab0JVIA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:00:28 -0400
Message-ID: <4CC14487.4020305@kernel.org>
Date: Fri, 22 Oct 2010 10:00:07 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-afs@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.36-rc7] afs: add afs_wq and use it instead of the
 system workqueue
References: <4CBDBE39.7080502@kernel.org> <25853.1287685570@redhat.com>
In-Reply-To: <25853.1287685570@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Oct 2010 08:00:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

On 10/21/2010 08:26 PM, David Howells wrote:
> Is that going away in the next merge window?

Probably not that soon.  I'm thinking about marking it deprecated in
the next merge window.

Thanks.

-- 
tejun
