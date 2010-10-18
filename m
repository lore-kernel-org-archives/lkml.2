Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab0JRVgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 17:36:11 -0400
Received: from smtp-out.google.com ([74.125.121.35]:25487 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab0JRVgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 17:36:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=KLCnQCMYzJLW106i050oRASiaLveEoFb8wW7Ts75PQXiAWq3ymx9pt/wuISPMDgRvm
         qMpFP6Ibd/xKs1L1aU0A==
Date: Mon, 18 Oct 2010 14:36:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] x86: Cleanup TIF value gaps in shift range
In-Reply-To: <4CBCBBFC.1090500@zytor.com>
Message-ID: <alpine.DEB.2.00.1010181431440.15782@chino.kir.corp.google.com>
References: <1287434158-24362-1-git-send-regression-fweisbec@gmail.com> <alpine.DEB.2.00.1010181340080.10965@chino.kir.corp.google.com> <alpine.LFD.2.00.1010182320440.6815@localhost6.localdomain6> <4CBCBBFC.1090500@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, H. Peter Anvin wrote:

> The problem is that someone exports something as debugging information,
> then someone else suddenly thinks it's an ABI.  I believe the same
> complainant in the past has objected to changing of formatting in dmesg,
> which is equally insane.
> 

It's not insane if there is no other way to ascertain that information.  
If it's available through sysfs or debugfs (and, even better, documented 
as part of the API in Documentation/ABI), then I don't think anyone would 
object to changing a log message.  But I don't think all log messages 
should be fair game under some general principle if they are being changed 
(instead of just extending it) without a compelling reason, such as 
technically being incorrect in its present form.
