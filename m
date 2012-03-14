Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030912Ab2CNOZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 10:25:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030522Ab2CNOZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 10:25:52 -0400
Date: Wed, 14 Mar 2012 10:25:43 -0400
From: Dave Jones <davej@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org, JBeulich@suse.com
Subject: Re: [PATCH 1/2] [CPUFREQ]: provide disable_cpufreq() function to
 disable the API.
Message-ID: <20120314142543.GB2371@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
	JBeulich@suse.com
References: <1331680720-18268-1-git-send-email-konrad.wilk@oracle.com>
 <1331680720-18268-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331680720-18268-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 07:18:39PM -0400, Konrad Rzeszutek Wilk wrote:
 > useful for disabling cpufreq altogether. The cpu frequency
 > scaling drivers and cpu frequency governors will fail to register.

looks good to me. Are you ok with me taking 1/2 through cpufreq.git, and
then you pushing the xen bit yourself ?
(or I could take them both if it makes things easier)

	Dave
