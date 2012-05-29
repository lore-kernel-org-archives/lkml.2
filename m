Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab2E2O13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 10:27:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab2E2O11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 10:27:27 -0400
Message-ID: <4FC4DCC7.7080401@redhat.com>
Date: Tue, 29 May 2012 17:27:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xudong Hao <xudong.hao@intel.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        takuya.yoshikawa@gmail.com, xiantao.zhang@intel.com,
        Haitao Shan <haitao.shan@intel.com>
Subject: Re: [PATCH v3 4/4] Enabling Access bit when doing memory swapping
References: <1337656995-24964-1-git-send-email-xudong.hao@intel.com>
In-Reply-To: <1337656995-24964-1-git-send-email-xudong.hao@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 06:23 AM, Xudong Hao wrote:
> <Re-send>
> 
> Enabling Access bit when doing memory swapping.
> 
> Changes from v2:
> -Still using claer_bit() function to make sure it's atomic operation.
> 

Thanks, applied.


-- 
error compiling committee.c: too many arguments to function
