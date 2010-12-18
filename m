Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab0LRPeu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:34:50 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:40470 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab0LRPet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:34:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=N4QCFoKbjOtiJTf9Xco5R9rU0PNTy5xd3y4LiR2cOUu/J0Y3KygJEbku/2PcbZYLOw
         e1sjvNI21aEIF8yP0lp8zhL5EdqIIDl6CTaU+S7wxK3/tK9DuV0XUm/fiVOE6/D2x7lo
         hwZMpSnE+/wKed4yaMJyHpa65iAC+2oFEfvF4=
Message-ID: <4D0CD495.2030300@gmail.com>
Date: Sat, 18 Dec 2010 16:34:45 +0100
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: gameport: use this_cpu_read instead of lookup
References: <20101214162842.542421046@linux.com>  <20101214162855.392020353@linux.com> <1292345072.5934.32.camel@edumazet-laptop> <alpine.DEB.2.00.1012141055220.17229@router.home> <4D07A2B7.8080405@zytor.com> <alpine.DEB.2.00.1012141109470.17229@router.home> <4D07A7CB.7010205@zytor.com> <4D07A95C.7030703@kernel.org> <4D0814AF.7080209@zytor.com> <4D08ECEF.3040909@kernel.org> <4D08EE57.8010602@zytor.com> <4D08EF4E.8070403@kernel.org> <4D0A3AF2.50508@gmail.com> <alpine.DEB.2.00.1012161214500.21588@router.home>
In-Reply-To: <alpine.DEB.2.00.1012161214500.21588@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 07:15 PM, Christoph Lameter wrote:
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
