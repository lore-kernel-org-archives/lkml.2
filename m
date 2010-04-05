Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab0DEObo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 10:31:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:50547 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab0DEObi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 10:31:38 -0400
Message-ID: <4BB9F513.2060405@kernel.org>
Date: Mon, 05 Apr 2010 23:34:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Wang, Yong Y" <yong.y.wang@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] eeepc-wmi: include slab.h
References: <4BB94DC1.5010403@kernel.org> <FC2FB65B4D919844ADE4BE3C2BB739AD1E03881D@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <FC2FB65B4D919844ADE4BE3C2BB739AD1E03881D@shsmsx501.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 05 Apr 2010 14:31:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2010 09:30 PM, Wang, Yong Y wrote:
> <linux/module.h> includes <linux/percpu.h> which in turn includes <linux/slab.h>.
> Doesn't it?

Yeah, I'm trying to break that implicit dependency.  :-)

-- 
tejun
