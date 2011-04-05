Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab1DEOV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:21:57 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33857 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab1DEOV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:21:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=F/cuHYiGiHvmENyawZ6hI+pDZlE+4iQ2KHmyVZHUMeGT9jkfzI9L8dcnJpi8PwU6R3
         zjXRs/ZSD/vAJ3aEMAPDtU+Tf+wQt2uLokdrNOsCgBJFmz7/ZnMFtQFDQAPbKkEyLZbU
         QXb1L3bVa4JIutyPD60TtmrZTOotfJgKIszkk=
Date: Tue, 5 Apr 2011 22:21:18 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Hui Zhu <teawater@gmail.com>
Cc: linux-kernel@vger.kernel.org, marc.khouzam@ericsson.com,
        thiago.bauermann@gmail.com, mqyoung@gmail.com, colyli@gmail.com,
        hch@infradead.org
Subject: Re: KGTP (Linux Kernel debugger and tracer) 20110405 release
Message-ID: <20110405142115.GA7565@gmail.com>
Mail-Followup-To: Hui Zhu <teawater@gmail.com>,
	linux-kernel@vger.kernel.org, marc.khouzam@ericsson.com,
	thiago.bauermann@gmail.com, mqyoung@gmail.com, colyli@gmail.com,
	hch@infradead.org
References: <BANLkTin7=j8-feeJw5fqDsMd9BYrq09KbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin7=j8-feeJw5fqDsMd9BYrq09KbQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 07:59:21PM +0800, Hui Zhu wrote:
> KGTP is a realtime and lightweight Linux Kernel GDB debugger and
> tracer that use Kprobe.
> 
> It make Linux Kernel supply a GDB remote debug interface. Then GDB in
> current machine or remote machine(see "Make GDB connect to gtp") can
> debug Linux through GDB tracepoint without stop the Linux Kernel.
> And even if the board doesn't have GDB on it and doesn't have
> interface for remote debug. It can debug the Linux Kernel use offline
> debug (See "Offline debug").
> Signed-off-by: Hui Zhu <teawater@gmail.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
 
I have used this tool. I think it is really a promising tool for debugging 
linux kernel. I will also study this tool and patch for it.
Thanks for Hui Zhu's patch for us.

Thanks.
Best Regards.
Harry Wei.
