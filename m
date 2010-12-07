Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab0LGPIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:08:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:33490 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab0LGPIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:08:15 -0500
Message-ID: <4CFE4D94.2060100@kernel.org>
Date: Tue, 07 Dec 2010 16:07:00 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, William Hubbs <w.d.hubbs@gmail.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [Use cpuops V1 08/11] Fakekey: Simplify speakup_fake_key_pressed
 through this_cpu_ops
References: <20101206171618.302060721@linux.com> <20101206171640.890602570@linux.com>
In-Reply-To: <20101206171640.890602570@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Dec 2010 15:07:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 06:16 PM, Christoph Lameter wrote:
> The whole function can be expressed as a simple this_cpu_read() operation.
> The function overhead is now likely multiple times that of the single
> instruction that is executed in it.
> 
> Cc: William Hubbs <w.d.hubbs@gmail.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

applied.

-- 
tejun
