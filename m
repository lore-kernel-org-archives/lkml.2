Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab0EJItY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 04:49:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499Ab0EJItX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 04:49:23 -0400
Message-ID: <4BE7C88D.8050504@redhat.com>
Date: Mon, 10 May 2010 11:49:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: update document of gfns
References: <4BE3D3A1.90707@cn.fujitsu.com>
In-Reply-To: <4BE3D3A1.90707@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2010 11:47 AM, Lai Jiangshan wrote:
> When don't use ->gfns when role.direct=1, update document for it.
>
>    


Please fold into the patch that does the change.

-- 
error compiling committee.c: too many arguments to function

