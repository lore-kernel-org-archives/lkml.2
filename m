Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab0KXMeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 07:34:09 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48506 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab0KXMeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 07:34:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VV4o6kOXHVMjNztHshpWROxru2KSZZMKvDsTgfcOlC8KTOBHR2aojvyeomEpmDwXZB
         kihY5UEmvJPiqDs3RxIJ33E+wVw5YCUiyDx+ZlcokWT1yrvdc/ifkOYUJ8e4K2B3HMvk
         jLWUwRydfGYaOo81NfbBS5YAuwpTS+x8+o/xw=
Date: Wed, 24 Nov 2010 20:37:26 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        tglx <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] scripts/tags.sh: Add magic for trace-events
Message-ID: <20101124123726.GC2922@hack>
References: <1290591835.2072.438.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290591835.2072.438.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 10:43:55AM +0100, Peter Zijlstra wrote:
>
>Make tags find the trace-event definitions
>
>Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.
