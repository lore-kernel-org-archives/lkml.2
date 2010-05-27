Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782Ab0E0JcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 05:32:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933159Ab0E0Jb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 05:31:59 -0400
Message-ID: <4BFE3C0A.5090607@redhat.com>
Date: Thu, 27 May 2010 12:31:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [PATCH] Fix SVM longmode guests
References: <4BFDC657.4040902@redhat.com>
In-Reply-To: <4BFDC657.4040902@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2010 04:09 AM, Zachary Amsden wrote:
> In recent testing, I discovered guests failed to boot on my AMD box.  
> Bisecting revealed an EFER related change caused the problem; here is 
> the fix.
>

Yikes, applied, thanks.

-- 
error compiling committee.c: too many arguments to function

