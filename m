Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab2K0Qnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 11:43:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:43853 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab2K0Qnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 11:43:52 -0500
Message-ID: <50B4EDBF.8070304@infradead.org>
Date: Tue, 27 Nov 2012 08:43:43 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>
Subject: Re: linux-next: Tree for Nov 27 (file notify)
References: <20121127172548.cd502ebfb903face1dc98554@canb.auug.org.au>
In-Reply-To: <20121127172548.cd502ebfb903face1dc98554@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 10:25 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20121126:
> 


when CONFIG_PROC_FS is not enabled (also seen in mmotm):

fs/notify/fanotify/fanotify_user.c:436:17: error: 'fanotify_show_fdinfo' undeclared here (not in a function)
fs/notify/inotify/inotify_user.c:333:17: error: 'inotify_show_fdinfo' undeclared here (not in a function)



-- 
~Randy
