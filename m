Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab0JUPeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:34:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:54067 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab0JUPeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:34:08 -0400
Message-ID: <4CC05D41.1090207@kernel.org>
Date: Thu, 21 Oct 2010 17:33:21 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Tom Tucker <tom@opengridcomputing.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-nfs@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Tom Tucker <tom@ogc.us>
Subject: Re: [PATCH linux-2.6.36-rc7] sunrpc/xprtrdma: clean up workqueue
 usage
References: <4CB87807.7050108@kernel.org> <20101015171132.GA18869@fieldses.org> <4CB89393.6000207@opengridcomputing.com> <4CB8A745.5020206@kernel.org> <4CBF1331.70107@opengridcomputing.com> <20101021151621.GA8738@fieldses.org>
In-Reply-To: <20101021151621.GA8738@fieldses.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Oct 2010 15:33:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 05:16 PM, J. Bruce Fields wrote:
>> I've tested this now with iozone etc... works like a charm ;-)
> 
> Applied, thanks!

Great, thank you.  :-)

-- 
tejun
