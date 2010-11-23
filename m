Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab0KWVuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 16:50:03 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57389 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab0KWVuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 16:50:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HxcItPIbMs4Z0ZJIpoXXK3THAkeQMIFmaIOrrXi1j7P798LyG2pslxMcOQP6xsKqV4
         i0l5DFjhAcKNVjaIXNsRoZcXmEorVTmQ8DMACxdkwzss7sIBKJWenA95wsIAFvcQ4C2R
         +kaT/1gmC+6hXfq0JgBhl82Ug7fgLy5H3T2u4=
Date: Wed, 24 Nov 2010 00:49:57 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, yinghai@kernel.org
Subject: Re: [PATCH 0/3 v2] x86: Remove old nmi_watchdog
Message-ID: <20101123214957.GD1839@lenovo>
References: <1290540725-2911-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290540725-2911-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 02:32:02PM -0500, Don Zickus wrote:
> Ingo asked me to remove the old nmi_watchdog to minimize the amount of
> code duplication we have to do for recent fixes.  All the functionality
> needed by the old nmi watchdog should be available in perf now.
> 

 Hi Don, if I understand correctly not many things are changed from previous
time, some tune ups here and there, right?

 Cyrill
