Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab0LHSqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 13:46:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:33490 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831Ab0LHSqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 13:46:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,316,1288594800"; 
   d="scan'208";a="581845428"
Message-ID: <4CFFD28B.8000800@linux.intel.com>
Date: Wed, 08 Dec 2010 10:46:35 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] select: remove unused MAX_SELECT_SECONDS
References: <1291791219-6500-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1291791219-6500-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/7/2010 10:53 PM, Namhyung Kim wrote:
> Remove the leftover from the commit 8ff3e8e85fa6 ("select:
> switch select() and poll() over to hrtimers").

fair enough

Acked-by: Arjan van de Ven <arjan@linux.intel.com>

