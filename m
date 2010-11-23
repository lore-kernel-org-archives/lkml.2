Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab0KWMl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 07:41:28 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56179 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab0KWMl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 07:41:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=ATgJNSf8r6Vnnvl9Lr5yvAcWo72jWHAS7Cd9rSQkmReSfn8kQU0lh0gaUjjp3zUdXm
         Xg646rvkauH3KC9cdQg0UGljH4kY3QaowLlkyV2TpX4v7U0Kp2zIOK+G4CWkmbPctTIe
         4E3IrtrT3jxrAc8FjSelMFQZ5S8ImicGqPweQ=
Date: Tue, 23 Nov 2010 10:41:21 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ian Munsie <imunsie@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/6] perf: Add timestamp to COMM and MMAP events
Message-ID: <20101123124121.GA11101@ghostprotocols.net>
References: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
 <1290490544-14349-4-git-send-email-imunsie@au1.ibm.com>
 <1290510512.2072.387.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290510512.2072.387.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 23, 2010 at 12:08:32PM +0100, Peter Zijlstra escreveu:
> Right, so acme had a patch adding
> 
> PERF_SAMPLE_TID
> PERF_SAMPLE_TIME
> PERF_SAMPLE_ID
> PERF_SAMPLE_CPU
> PERF_SAMPLE_STREAM_ID
> 
> (IIRC) to every record.. so solve this same problem. Except he got
> interrupted by KS and things and didn't get around to posting it.
> 
> Arnaldo?

Will post later today, IIRC I have to break it down because I did some
refactorings, etc.

- Arnaldo
