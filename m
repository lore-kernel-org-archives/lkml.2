Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab2GQVkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:40:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48484 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab2GQVkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:40:14 -0400
Date: Tue, 17 Jul 2012 14:40:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 2/3] cgroup: revise how we re-populate root directory
Message-ID: <20120717214010.GF24336@google.com>
References: <20120702142925.795007114@napanee.usersys.redhat.com>
 <20120702142926.405632285@napanee.usersys.redhat.com>
 <20120709171748.GD1341@google.com>
 <20120709172220.GE1341@google.com>
 <20120709172831.GF1341@google.com>
 <20120710192721.GB19791@redhat.com>
 <20120717183851.GA24336@google.com>
 <20120717212926.GB26916@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120717212926.GB26916@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 17, 2012 at 05:29:27PM -0400, Aristeu Rozanski wrote:
> what about this version:

Yeah, generally looks good to me although @added/removed_bits argument
names irk me a bit.  The name may be okay for local variables but I
keep thinking "what bits?".  @subsys_mask or something indicating that
it's mask of subsystems would better.  Also, can you please add /**
function comment explaining the clear/populate functions and their
arguments?

Thanks!

-- 
tejun
