Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762239Ab2EQRiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 13:38:54 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38927 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762209Ab2EQRix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 13:38:53 -0400
Date: Thu, 17 May 2012 21:38:48 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [rfc 2/4] procfs: Convert /proc/pid/fdinfo/fd handling routines
 into seq-file with fdinfo helpers
Message-ID: <20120517173848.GE6183@moon>
References: <20120517160738.116113099@openvz.org>
 <20120517162534.681059644@openvz.org>
 <4FB52804.8090004@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB52804.8090004@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 08:32:04PM +0400, Pavel Emelyanov wrote:
> 
> I would split this into two parts -- the 1st one turns fdinfo into seq-files
> and the 2nd one adds the fdinfo helpers. This will make the review MUCH simpler.

Yeah, will do and send. Thanks.

	Cyrill
