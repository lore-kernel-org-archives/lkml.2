Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab1DUIck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 04:32:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab1DUIcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 04:32:36 -0400
Message-ID: <4DAFEB9D.4040402@redhat.com>
Date: Thu, 21 Apr 2011 11:32:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com,
        jbarnes@virtuousgeek.org
Subject: Re: [PATCH v3 0/3] Store and load PCI device saved state across function
 resets
References: <20110420202523.3189.31306.stgit@s20.home>
In-Reply-To: <20110420202523.3189.31306.stgit@s20.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2011 11:31 PM, Alex Williamson wrote:
> v2 ->  v3:
>    Saved structure has variable contents.
>
> Avi, see if this adds any credibility to the pci-core allocated
> opaque buffer.  It was wrong in the previous versions to distill
> the variable device capability save list into a fixed struct.
> This should also eliminate any future maintenance specific to
> this storing and loading of state as capability save changes.
>

Haha, nice trick.  Yes, it does.

-- 
error compiling committee.c: too many arguments to function

