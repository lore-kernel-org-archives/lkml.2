Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab0GJWbi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 18:31:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53176 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab0GJWbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 18:31:36 -0400
Message-ID: <4C38F489.3090607@zytor.com>
Date: Sat, 10 Jul 2010 15:30:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2] x86: Early-boot serial I/O support
References: <1278790820-1817-1-git-send-email-penberg@cs.helsinki.fi> <20100710210750.GC6615@lenovo> <4C38E7FD.9020403@zytor.com> <20100710215554.GE6615@lenovo>
In-Reply-To: <20100710215554.GE6615@lenovo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2010 02:55 PM, Cyrill Gorcunov wrote:
> 
> I rather wonder -- can't we use cpu_relax() from processor.h? Or there
> is some type conflicts?
> 

Probably.  The boot environment is pretty different, and not sharing
header files where we don't need to because of shared data structures is
probably a good idea.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

