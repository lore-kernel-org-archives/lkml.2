Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab0LaMn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 07:43:58 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38129 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab0LaMn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 07:43:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wRCUR4m5sVh35Ije7fcnP7btMxBytS8eHlZ9549k1zAaJEoFooaqyZJNdqbJnA6nuG
         YVgh7TEdG9PjZWyL8AEoonfTMS5doSrZsBDnHn9q5Xg/tiDdBiB7GtoHfL0PtOqIV/TZ
         Jm1/LPRYQy8ba2rZEp2IZHENg3F6gCBUBV38M=
Date: Fri, 31 Dec 2010 13:43:52 +0100
From: Tejun Heo <htejun@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: x86: Use this_cpu_has for thermal_interrupt
Message-ID: <20101231124352.GJ18831@htj.dyndns.org>
References: <4D0814AF.7080209@zytor.com>
 <4D08ECEF.3040909@kernel.org>
 <4D08EE57.8010602@zytor.com>
 <4D08EF4E.8070403@kernel.org>
 <4D0A3AF2.50508@gmail.com>
 <alpine.DEB.2.00.1012161212130.21588@router.home>
 <4D0CD4C6.5010309@gmail.com>
 <4D0FFB33.8020309@zytor.com>
 <20101230112933.GB18831@htj.dyndns.org>
 <4D1CCD48.5000702@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1CCD48.5000702@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 10:19:52AM -0800, H. Peter Anvin wrote:
> Acked-by: H. Peter Anvin <hpa@zytor.com>

Three patches committed to percpu#for-2.6.38.  Thanks.

-- 
tejun
