Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610Ab2BOMfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 07:35:50 -0500
Received: from smtprelay05.ispgateway.de ([80.67.31.98]:42615 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758188Ab2BOMf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 07:35:26 -0500
Message-ID: <4F3BA700.905@ladisch.de>
Date: Wed, 15 Feb 2012 13:37:20 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christopher Cherrett <ccherrett@openoctave.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Juce plugins cause realtime kernel lockup
References: <4F3B759B.9090008@openoctave.org>
In-Reply-To: <4F3B759B.9090008@openoctave.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christopher Cherrett wrote:
> When you use a plugin compiled with juce the whole system hangs. This only happens with the RT kernel and not the standard PREEMPT kernel.
>
> The system will not shut down but needs a hard boot, spewing hpet errors.

What errors?


Regards,
Clemens
