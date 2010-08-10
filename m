Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab0HJL4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 07:56:22 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:20556 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab0HJL4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 07:56:17 -0400
Date: Tue, 10 Aug 2010 14:54:38 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: "Balbi Felipe (Nokia-MS/Helsinki)" <felipe.balbi@nokia.com>,
        David Howells <dhowells@redhat.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vamos-dev@i4.informatik.uni-erlangen.de" 
	<vamos-dev@i4.informatik.uni-erlangen.de>
Subject: Re: [PATCH 1/4] arch/frv: Removing dead RAMKERNEL config option
Message-ID: <20100810115438.GF22436@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <cover.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
 <c80d5af9b2921e9d8cc6d8d7b9a54a882f1c919e.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
 <20100810093717.GD22436@nokia.com>
 <864of2ybzb.fsf@peer.zerties.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <864of2ybzb.fsf@peer.zerties.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 12:54:16PM +0200, ext Christian Dietrich wrote:
>If you take a look at init/main.c:826 free_initmem() is called. perhaps
>this can be resolved with a macro, but if anybody in the future wants to
>add some functionality there, he won't be happy after grepping.

ok, sorry for that. Makes sense.

-- 
balbi

DefectiveByDesign.org
