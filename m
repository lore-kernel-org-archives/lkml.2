Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab0JELzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 07:55:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60020 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab0JELzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 07:55:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kXTCQrlMZag2BbvFVo8ybWsQVce06LQg3Thj75dgmvJp6/CZsYCDr7jFGWMLlkApwj
         BLSUVj6D6wjWxwIveD1FpBLV5SE/B2+MmEd64CNwpqPsPYibKdMuTlX3VVyupHVSJ4PX
         Th9QpaZus6iuykyOrfCbiWg9CvXdDExw2VvW0=
Date: Tue, 5 Oct 2010 19:59:58 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Philip Wernersbach <philip.wernersbach@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Detecting runnable process?
Message-ID: <20101005115958.GJ5170@cr0.nay.redhat.com>
References: <AANLkTimKpVR5UVYLetwt=S4PSkMEJTBpUk7Q-o=ha_ds@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimKpVR5UVYLetwt=S4PSkMEJTBpUk7Q-o=ha_ds@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 09:39:16PM -0400, Philip Wernersbach wrote:
>I'm writing some kernel code that given a task's task_struct must
>decide if it is runnable, and hasn't crashed or exited. So far here's
>what I've come up with:
>
>struct task_struct *my_task;
>... snip ...
>if(likely(my_task != NULL && pid_alive(my_task) == true)) { return my_task; }
>
>Is this correct?
>

Yes to me, you can also check the functions which call pid_alive() in kernel.
